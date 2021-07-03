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