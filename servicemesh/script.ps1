az login
az account set --subscription "e9311502-a3d1-4b22-b06f-5ba84ffbe565"
az group create --name ServiceMeshDemo --location westeurope

az mesh deployment create --resource-group ServiceMeshDemo --template-file .\Application.json --parameters "{'location': {'value': 'westeurope'}}"

az mesh gateway show -g ServiceMeshDemo -n visualObjectsGateway -o table

az mesh app show --resource-group ServiceMeshDemo --name visualObjectsApp

az mesh code-package-log get --resource-group ServiceMeshDemo --application-name visualObjectsApp --service-name web --replica-name 0 --code-package-name code

az group delete --name ServiceMeshDemo