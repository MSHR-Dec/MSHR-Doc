# wasm-demo-app
see: https://www.cncf.io/blog/2024/03/28/webassembly-on-kubernetes-the-practice-guide-part-02/

## Run Wasm on the host system
- `$ docker run -it --rm -v ./wasm-demo-app:/wasm -w /wasm --name ubuntu ubuntu:jammy bash`
- `# apt update`
- `# apt install -y curl gcc git python3`
- `# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
- `# source "$HOME/.cargo/env"`
- `# rustup target add wasm32-wasi`
- `# cd http-server/`
- `# vim Cargo.toml`
- `# vim src/main.rs`
- `# cargo build --target wasm32-wasi --release`
- `# curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash`
- `# source /root/.bashrc`
- `# wasmedge target/wasm32-wasi/release/http-server.wasm`
- `$ docker exec -it ubuntu bash`
- `# curl http://localhost:8080`

## Run Wasm in Linux containers
- `$ cd wasm-demo-app/`
- `$ vim Dockerfile-wasmedge-slim`
- `$ docker build -f Dockerfile-wasmedge-slim -t wasm-demo-app:slim .`
- `$ docker run -itd -p 8080:8080 --name wasm-demo-app wasm-demo-app:slim`
- `$ curl http://localhost:8080`

## Run Wasm on Docker Desktop
[Turning on Wasm workloads](https://docs.docker.com/desktop/wasm/#turn-on-wasm-workloads).
- `$ vim Dockerfile`
- `$ docker build -t wasm-demo-app:v1 .`
- `$ docker run -d -p 8080:8080 --name=wasm-demo-app --runtime=io.containerd.wasmedge.v1 wasm-demo-app:v1`
- `$ curl http://localhost:8080`

## Run Wasm on Kubernetes
- `$ kind create cluster --name wasm-demo`
- `$ docker exec -it wasm-demo-control-plane bash`
- `# apt update`
- `Install required packages`
```
apt install -y make git gcc build-essential pkgconf libtool \
    libsystemd-dev libprotobuf-c-dev libcap-dev libseccomp-dev libyajl-dev \
    go-md2man libtool autoconf python3 automake vim
```
- `# curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash`
- `# source $HOME/.wasmedge/env`
- `# git clone https://github.com/containers/crun`
- `# cd crun`
- `# ./autogen.sh`
- `# ./configure --with-wasmedge`
- `# make`
- `# make install`
- `# mkdir $HOME/test-crun; cd $_`
- `# mkdir rootfs`
- `$ docker cp http-server/target/wasm32-wasi/release/http-server.wasm wasm-demo-control-plane:/root/test-crun/rootfs/`
- `$ docker cp config.json wasm-demo-control-plane:/root/test-crun/`
- `$ docker cp config.toml wasm-demo-control-plane:/etc/containerd/`
- `# crun run wasm-demo-app`
- `# curl http://localhost:8080`
- `# crun kill wasm-demo-app SIGKILL`
- `# systemctl restart containerd`
- `$ kubectl label nodes wasm-demo-control-plane runtime=crun`
- `$ kind load docker-image --name wasm-demo wasm-demo-app:v1`
- `$ kubectl apply -f runtimeclass.yaml`
- `$ kubectl apply -f pod.yaml`
- `$ kubectl port-forward pod/wasm-demo-app 8080:8080`
- `$ curl http://localhost:8080`
- `$ kind delete cluster --name wasm-demo`
