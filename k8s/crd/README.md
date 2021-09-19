# crd
## code_generator
This is my first custom controller created by using `code-generator`.

I did the following procedure.

### Environment
Docker for Mac with kubernetes.

### Create the following files.
```
code_generator/pkg/apis/myfirstcontroller/register.go
code_generator/pkg/apis/myfirstcontroller/v1alpha1/doc.go
code_generator/pkg/apis/myfirstcontroller/v1alpha1/register.go
code_generator/pkg/apis/myfirstcontroller/v1alpha1/types.go
```

### Execute the following commands.
```
go get k8s.io/client-go/...
go get k8s.io/apimachinery/...
go get github.com/golang/glog
go get k8s.io/code-generator/...
```

### Generate the essential GO codes automatically.
```
$GOPATH/pkg/mod/k8s.io/code-generator@v0.22.1/generate-groups.sh \
    all \
    MSHR-Doc/k8s/crd/code_generator/pkg/generated \
    MSHR-Doc/k8s/crd/code_generator/pkg/apis myfirstcontroller:v1alpha1 \
    -h $GOPATH/pkg/mod/k8s.io/code-generator@v0.22.1/hack/boilerplate.go.txt \
    -o ../../../
```

### Build my controller for deploying to kubernetes.
```
docker build -f docker/code_generator/Dockerfile -t myfirstcontroller .
```

### Deploy my controller to kubernetes.
```
kubectl apply -f manifest/myfirstcontroller
```
