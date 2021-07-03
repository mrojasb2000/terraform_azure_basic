# Azure DevOps Terraform Provider

Prerequisites:

Before you begin, you'll need an [Azure subscription](https://azure.microsoft.com/en-us/). Create a free account or use an existing sandbox subscription.

We will be using the Azure Cloud Shell as Terraform already comes preinstalled in this environment and is the fastest way to get started. To launch Azure Cloud Shell, browse to shell.azure.com.



## Basic usage Terraform

### Create gitignore file 
```
$ npx gitignore terraform
```

1. Set environment variables
```
$ export AZDO_ORG_SERVICE_URL="https://dev.azure.com/MY_ORGANIZATON"
$ export AZDO_PERSONAL_ACCESS_TOKEN="USER_TOKEN"
$ export TF_VAR_system=terraformdemo
$ export TF_VAR_location=eastus
```

2. Initialize Terraform provider
```
$ terraform init
```

3. Execute Terraform plan
```
$ terraform plan -var="system=terraformdemo" -var="location=eastus" -out tfplan 
```

4. Review the plan 
````
$ terraform show tfplan
$ terraform show -json tfplan
terraform show -json tfplan | jq '.' > tfplan.json
```

5. Create infrastructure
```
$ terraform apply -var="system=terraformdemo" -var="location=eastus" -auto-approve
```

6. Destroy infrastructure
```
$ terraform plan -destroy -out=tfvmdestroy
$ terraform destroy tfvmdestroy -auto-approve
```


## Create a DevOps project including a hosted Git repo
