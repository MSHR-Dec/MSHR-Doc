package main

import (
	"context"
	"fmt"
	"time"

	batchv1 "k8s.io/api/batch/v1"
	corev1 "k8s.io/api/core/v1"
	"k8s.io/apimachinery/pkg/api/errors"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	utilruntime "k8s.io/apimachinery/pkg/util/runtime"
	"k8s.io/apimachinery/pkg/util/wait"
	batchinformers "k8s.io/client-go/informers/batch/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/kubernetes/scheme"
	typedcorev1 "k8s.io/client-go/kubernetes/typed/core/v1"
	batchlisters "k8s.io/client-go/listers/batch/v1"
	"k8s.io/client-go/tools/cache"
	"k8s.io/client-go/tools/record"
	"k8s.io/client-go/util/workqueue"
	"k8s.io/klog/v2"

	myfirstcontrollerv1alpha1 "github.com/MSHR-Dec/MSHR-Doc/k8s/aqua-tilt/go/pkg/apis/myfirstcontroller/v1alpha1"
	clientset "github.com/MSHR-Dec/MSHR-Doc/k8s/aqua-tilt/go/pkg/generated/clientset/versioned"
	myfirstcontrollerscheme "github.com/MSHR-Dec/MSHR-Doc/k8s/aqua-tilt/go/pkg/generated/clientset/versioned/scheme"
	informers "github.com/MSHR-Dec/MSHR-Doc/k8s/aqua-tilt/go/pkg/generated/informers/externalversions/myfirstcontroller/v1alpha1"
	listers "github.com/MSHR-Dec/MSHR-Doc/k8s/aqua-tilt/go/pkg/generated/listers/myfirstcontroller/v1alpha1"
)

const controllerAgentName = "mineController"

const (
	SuccessSynced         = "Synced"
	ErrResourceExists     = "ErrResourceExists"
	MessageResourceExists = "Resource %q already exists and is not managed by mineController"
	MessageResourceSynced = "mineController synced successfully"
)

type Controller struct {
	kubeclientset kubernetes.Interface
	mineclientset clientset.Interface

	jobLister batchlisters.JobLister
	jobSynced cache.InformerSynced
	mineLister        listers.MineLister
	mineSynced        cache.InformerSynced

	workqueue workqueue.RateLimitingInterface
	recorder  record.EventRecorder
}

func NewController(
	kubeclientset kubernetes.Interface,
	mineclientset clientset.Interface,
	jobInformer batchinformers.JobInformer,
	mineInformer informers.MineInformer) *Controller {

	utilruntime.Must(myfirstcontrollerscheme.AddToScheme(scheme.Scheme))
	klog.V(4).Info("Creating event broadcaster")
	eventBroadcaster := record.NewBroadcaster()
	eventBroadcaster.StartStructuredLogging(0)
	eventBroadcaster.StartRecordingToSink(&typedcorev1.EventSinkImpl{Interface: kubeclientset.CoreV1().Events("")})
	recorder := eventBroadcaster.NewRecorder(scheme.Scheme, corev1.EventSource{Component: controllerAgentName})

	controller := &Controller{
		kubeclientset:     kubeclientset,
		mineclientset:     mineclientset,
		jobLister: jobInformer.Lister(),
		jobSynced: jobInformer.Informer().HasSynced,
		mineLister:        mineInformer.Lister(),
		mineSynced:        mineInformer.Informer().HasSynced,
		workqueue:         workqueue.NewNamedRateLimitingQueue(workqueue.DefaultControllerRateLimiter(), "Mines"),
		recorder:          recorder,
	}

	klog.Info("Setting up event handlers")
	mineInformer.Informer().AddEventHandler(cache.ResourceEventHandlerFuncs{
		AddFunc: controller.enqueueMine,
		UpdateFunc: func(old, new interface{}) {
			controller.enqueueMine(new)
		},
	})
	jobInformer.Informer().AddEventHandler(cache.ResourceEventHandlerFuncs{
		AddFunc: controller.handleObject,
		UpdateFunc: func(old, new interface{}) {
			newDepl := new.(*batchv1.Job)
			oldDepl := old.(*batchv1.Job)
			if newDepl.ResourceVersion == oldDepl.ResourceVersion {
				return
			}
			controller.handleObject(new)
		},
		DeleteFunc: controller.handleObject,
	})

	return controller
}

func (c Controller) Run(workers int, stopCh <-chan struct{}) error {
	defer utilruntime.HandleCrash()
	defer c.workqueue.ShutDown()

	klog.Info("Starting Mine controller")

	klog.Info("Waiting for informer caches to sync")
	if ok := cache.WaitForCacheSync(stopCh, c.jobSynced, c.mineSynced); !ok {
		return fmt.Errorf("failed to wait for caches to sync")
	}

	klog.Info("Starting workers")
	for i := 0; i < workers; i++ {
		go wait.Until(c.runWorker, time.Second, stopCh)
	}

	klog.Info("Started workers")
	<-stopCh
	klog.Info("Shutting down workers")

	return nil
}

func (c *Controller) runWorker() {
	for c.processNextWorkItem() {
	}
}

func (c *Controller) processNextWorkItem() bool {
	obj, shutdown := c.workqueue.Get()

	if shutdown {
		return false
	}

	err := func(obj interface{}) error {
		defer c.workqueue.Done(obj)
		var key string
		var ok bool
		if key, ok = obj.(string); !ok {
			c.workqueue.Forget(obj)
			utilruntime.HandleError(fmt.Errorf("expected string in workqueue but got %#v", obj))
			return nil
		}
		if err := c.syncHandler(key); err != nil {
			c.workqueue.AddRateLimited(key)
			return fmt.Errorf("error syncing '%s': %s, requeuing", key, err.Error())
		}
		c.workqueue.Forget(obj)
		klog.Infof("Successfully synced '%s'", key)
		return nil
	}(obj)

	if err != nil {
		utilruntime.HandleError(err)
		return true
	}

	return true
}

func (c *Controller) syncHandler(key string) error {
	namespace, name, err := cache.SplitMetaNamespaceKey(key)
	if err != nil {
		utilruntime.HandleError(fmt.Errorf("invalid resource key: %s", key))
		return nil
	}

	mine, err := c.mineLister.Mines(namespace).Get(name)
	if err != nil {
		if errors.IsNotFound(err) {
			utilruntime.HandleError(fmt.Errorf("mine '%s' in work queue no longer exists", key))
			return nil
		}

		return err
	}

	jobName := mine.Spec.JobName
	if jobName == "" {
		utilruntime.HandleError(fmt.Errorf("%s: job name must be specified", key))
		return nil
	}

	job, err := c.jobLister.Jobs(mine.Namespace).Get(jobName)
	if errors.IsNotFound(err) {
		job, err = c.kubeclientset.BatchV1().Jobs(mine.Namespace).Create(context.TODO(), newJob(mine), metav1.CreateOptions{})
	}

	if err != nil {
		return err
	}

	if !metav1.IsControlledBy(job, mine) {
		msg := fmt.Sprintf(MessageResourceExists, job.Name)
		c.recorder.Event(mine, corev1.EventTypeWarning, ErrResourceExists, msg)
		return fmt.Errorf(msg)
	}

	// if mine.Spec.Replicas != nil && *mine.Spec.Replicas != *job.Spec.Replicas {
	// 	klog.V(4).Infof("Mine %s replicas: %d, job replicas: %d", name, *mine.Spec.Replicas, *job.Spec.Replicas)
	// 	job, err = c.kubeclientset.BatchV1().Jobs(mine.Namespace).Update(context.TODO(), newJob(mine), metav1.UpdateOptions{})
	// }

	if err != nil {
		return err
	}

	// err = c.updateMineStatus(mine, job)
	// if err != nil {
	// 	return err
	// }

	c.recorder.Event(mine, corev1.EventTypeNormal, SuccessSynced, MessageResourceSynced)
	return nil
}

// func (c *Controller) updateMineStatus(mine *myfirstcontrollerv1alpha1.Mine, job *batchv1.Job) error {
// 	mineCopy := mine.DeepCopy()
// 	mineCopy.Status.AvailableReplicas = job.Status.AvailableReplicas
// 	_, err := c.mineclientset.MyfirstcontrollerV1alpha1().Mines(mine.Namespace).Update(context.TODO(), mineCopy, metav1.UpdateOptions{})
// 	return err
// }

func (c *Controller) enqueueMine(obj interface{}) {
	var key string
	var err error
	if key, err = cache.MetaNamespaceKeyFunc(obj); err != nil {
		utilruntime.HandleError(err)
		return
	}
	c.workqueue.Add(key)
}

func (c *Controller) handleObject(obj interface{}) {
	var object metav1.Object
	var ok bool
	if object, ok = obj.(metav1.Object); !ok {
		tombstone, ok := obj.(cache.DeletedFinalStateUnknown)
		if !ok {
			utilruntime.HandleError(fmt.Errorf("error decoding object, invalid type"))
			return
		}
		object, ok = tombstone.Obj.(metav1.Object)
		if !ok {
			utilruntime.HandleError(fmt.Errorf("error decoding object tombstone, invalid type"))
			return
		}
		klog.V(4).Infof("Recovered deleted object '%s' from tombstone", object.GetName())
	}
	klog.V(4).Infof("Processing object: %s", object.GetName())
	if ownerRef := metav1.GetControllerOf(object); ownerRef != nil {
		if ownerRef.Kind != "mine" {
			return
		}

		mine, err := c.mineLister.Mines(object.GetNamespace()).Get(ownerRef.Name)
		if err != nil {
			klog.V(4).Infof("ignoring orphaned object '%s' of mine '%s'", object.GetSelfLink(), ownerRef.Name)
			return
		}

		c.enqueueMine(mine)
		return
	}
}

func newJob(mine *myfirstcontrollerv1alpha1.Mine) *batchv1.Job {
	labels := map[string]string{
		"app":        "hello-sample",
		"controller": mine.Name,
	}
	var backOffLimit int32 = 0

	return &batchv1.Job{
		ObjectMeta: metav1.ObjectMeta{
			Name:      mine.Spec.JobName,
			Namespace: mine.Namespace,
			OwnerReferences: []metav1.OwnerReference{
				*metav1.NewControllerRef(mine, myfirstcontrollerv1alpha1.SchemeGroupVersion.WithKind("mine")),
			},
		},
		Spec: batchv1.JobSpec{
			Template: corev1.PodTemplateSpec{
				ObjectMeta: metav1.ObjectMeta{
					Labels: labels,
				},
				Spec: corev1.PodSpec{
					Containers: []corev1.Container{
						{
							Name:  "hello-sample",
							Image: mine.Spec.Image,
						},
					},
				},
			},
			BackoffLimit: &backOffLimit,
		},
	}
}
