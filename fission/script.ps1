# Setup cluster
az login
az account set --subscription "e9311502-a3d1-4b22-b06f-5ba84ffbe565"
az group create --name fissionDemo --location westeurope
az aks create --resource-group fissionDemo --name fissionDemo --node-count 1 --enable-addons monitoring --generate-ssh-keys --disable-rbac

#Install kubectl & helm
az aks install-cli
az aks get-credentials --resource-group fissionDemo --name fissionDemo
kubectl get nodes
az aks browse --resource-group fissionDemo --name fissionDemo

choco install kubernetes-helm

#Install Fission
$FissionNamespace = "fission"
kubectl create namespace $FissionNamespace
helm install --namespace $FissionNamespace --name-template fission https://github.com/fission/fission/releases/download/1.7.1/fission-all-1.7.1.tgz

#Install Fission CLI (manually on Windows)

#Use Fission - Node
.\fission.exe env create --name nodejs --image fission/node-env:1.7.1
.\fission.exe function create --name hellojs --env nodejs --code hello.js
.\fission.exe function test --name hellojs

#Use Fission - Go
.\fission.exe env create --name go --image fission/go-env:1.7.1 --builder fission/go-builder:1.7.1
.\fission.exe function create --name gohello --env go --src hello.go --entrypoint Handler
.\fission.exe function test --name gohello

#Create HTTP Trigger
.\fission.exe httptrigger create --name helloworld --method GET --url "/helloworld" --function hellojs
$ipAddress = kubectl get service router -n fission -o jsonpath='{.status.loadBalancer.ingress[*].ip}'
Invoke-WebRequest "http://$ipAddress/helloworld"

#Delete resources
az group delete --name fissionDemo --yes --no-wait