package v1alpha1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// +genclient
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// MyFirstController is a specification for a MyFirstController resource
type MyFirstController struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   MyFirstControllerSpec   `json:"spec"`
	Status MyFirstControllerStatus `json:"status"`
}

// MyFirstControllerSpec is the spec for a MyFirstController resource
type MyFirstControllerSpec struct {
	DeploymentName string `json:"deploymentName"`
	Replicas       *int32 `json:"replicas"`
}

// MyFirstControllerStatus is the status for a MyFirstController resource
type MyFirstControllerStatus struct {
	AvailableReplicas int32 `json:"availableReplicas"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// MyFirstControllerList is a list of MyFirstController resource
type MyFirstControllerList struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Items []MyFirstController `json:"items"`
}
