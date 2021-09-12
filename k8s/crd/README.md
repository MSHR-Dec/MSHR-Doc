# crd
First, create the following files.
```
pkg/apis/myfirstcontroller/register.go
pkg/apis/myfirstcontroller/v1alpha1/doc.go
pkg/apis/myfirstcontroller/v1alpha1/register.go
pkg/apis/myfirstcontroller/v1alpha1/types.go
```

And then, execute the following commands.
```
go get k8s.io/client-go/...
go get k8s.io/apimachinery/...
go get github.com/golang/glog
go get k8s.io/code-generator/...
```

Finally, generate the essential codes automatically.
```
$GOPATH/pkg/mod/k8s.io/code-generator@v0.22.1/generate-groups.sh \
    all \
    ../crd/pkg/generated \
    ../crd/pkg/apis myfirstcontroller:v1alpha1 \
    -h $GOPATH/pkg/mod/k8s.io/code-generator@v0.22.1/hack/boilerplate.go.txt \
    -o ./
```
