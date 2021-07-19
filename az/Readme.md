# Azure PowerShell

Azure PowerShell on Alpine Linux, for provisioning Azure resources

The following PowerShell modules are installed:

- [Az.Accounts](https://www.powershellgallery.com/packages/Az.Accounts)
- [Az.Functions](https://www.powershellgallery.com/packages/Az.Functions)
- [Az.Resources](https://www.powershellgallery.com/packages/Az.Resources)
- [Az.Storage](https://www.powershellgallery.com/packages/Az.Storage)

This Docker image supports automated resource provisioning and application 
deployment to Azure. The [`Connect-AzAccount`][credentials] cmdlet is 
used for authentication, which requires the tentant ID and the credentials of 
an authorized service principal. An example is given in [`example.ps1`](example.ps1), 
which uses the environment variables shown in the command below to authenticate.

```
docker run --rm -it -v $PWD:/src --env AZ_CLIENT_ID --env AZ_CLIENT_SECRET --env AZ_TENANT_ID az -File example.ps1
```

[credentials]: https://docs.microsoft.com/en-us/powershell/module/az.accounts/Connect-AzAccount

## Contributing

### How to: update PowerShell

Find the Docker tag corresponding to a newer version of PowerShell on Alpine 
Linux [here](https://hub.docker.com/_/microsoft-powershell) and update the 
`FROM` statement in the Dockerfile accordingly.

After building the local Docker image run it to check the PowerShell version:

```
docker run --rm -it az -Version
```

### How to: update Azure PowerShell

Check the latest version of the [`Az`](https://www.powershellgallery.com/packages/Az) 
module and check its dependencies for updates of the PowerShell modules that 
are installed and update the `-RequiredVersion` argument in the corresponding 
`Install-Module` commands in the Dockerfile accordingly.

### How to: test Azure PowerShell

```
docker run --rm -it az -Command Get-AzEnvironment
```
