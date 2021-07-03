# Azure DevOps Terraform Provider

Prerequisites:

Before you begin, you'll need an [Azure subscription](https://azure.microsoft.com/en-us/). Create a free account or use an existing sandbox subscription.

We will be using the Azure Cloud Shell as Terraform already comes preinstalled in this environment and is the fastest way to get started. To launch Azure Cloud Shell, browse to shell.azure.com.

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
## Deploy infrastructure

1. Initialize Terraform provider
```
$ terraform init
```

2. Execute Terraform plan
```
$ terraform plan -var="system=terraformdemo" -var="location=eastus" -out tfplan 
```

3. Review the plan 
```
$ terraform show tfplan
$ terraform show -json tfplan
terraform show -json tfplan | jq '.' > tfplan.json
```

4. Create infrastructure
```
$ terraform apply -var="system=terraformdemo" -var="location=eastus" -auto-approve
```

5. Destroy infrastructure
```
$ terraform plan -destroy -out=tfvmdestroy
$ terraform destroy tfvmdestroy -auto-approve
```

## Deploy the code

By default Azure Functions Core Tools upload full content of the current folder minus files matching patterns in .funcignore 
```
$ printf "\nterraform/*" >> .funcignore
```

### Exclude dev dependecies
You may also want to exclude dev dependecies from your **node_mudoles** before code upload.

```
$ npm run build:production
> build:production
> npm run prestart && npm prune --production


> prestart
> npm run build && func extensions install


> build
> tsc

No action performed. Extension bundle is configured in /Users/mavro/Projects/Azure/terraform_azure_basic/Functions/basic/host.json.

up to date, audited 1 package in 798ms

found 0 vulnerabilities
```

### Publish the code
Publish the code (run the command in the root folder where the package.json file is). Add argument with your function name (from Terraform outputs)

```
$ func azure functionapp publish vatazurestgo-dev-fun-app                   
Getting site publishing info...
Uploading package...
Uploading 11,33 KB [##############################################################################]
Upload completed successfully.
Deployment completed successfully.
Syncing triggers...
Functions in vatazurestgo-dev-fun-app:
    hello-world - [httpTrigger]
        Invoke url: https://vatazurestgo-dev-fun-app.azurewebsites.net/api/hello-world
```

## Cleanup infrastructure

```
$ terraform destroy
```