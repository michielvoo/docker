# Azure PowerShell

Azure PowerShell on Alpine Linux, for provisioning Azure resources

The following PowerShell modules are installed:

- [Az.Accounts](https://www.powershellgallery.com/packages/Az.Accounts)
- [Az.Functions](https://www.powershellgallery.com/packages/Az.Functions)
- [Az.Resources](https://www.powershellgallery.com/packages/Az.Resources)
- [Az.Storage](https://www.powershellgallery.com/packages/Az.Storage)

## How to: update PowerShell

Find the Docker tag corresponding to a newer version of PowerShell on Alpine 
Linux [here](https://hub.docker.com/_/microsoft-powershell) and update the 
`FROM` statement in the Dockerfile accordingly.

After building the local Docker image run it to check the PowerShell version:

```
docker run --rm -it az -Version
```

## How to: update Azure PowerShell

Find the latest version of the PowerShell that are installed and update the 
 `-RequiredVersion` argument in the corresponding commands in the Dockerfile 
 accordingly.

## How to: test Azure PowerShell

Run the local Docker image to execute the `test.ps1` script, while making sure 
the required environment variables are set correctly:

```
docker run --rm -it -v $PWD:/src --env AZ_CLIENT_ID --env AZ_CLIENT_SECRET --env AZ_TENANT_ID az -File test.ps1
```
