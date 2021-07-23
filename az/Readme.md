# Azure PowerShell

Azure PowerShell and Git on Alpine Linux, for provisioning Azure resources

The following PowerShell modules are installed:

- [Az.Accounts](https://www.powershellgallery.com/packages/Az.Accounts)
- [Az.Functions](https://www.powershellgallery.com/packages/Az.Functions)
- [Az.Resources](https://www.powershellgallery.com/packages/Az.Resources)
- [Az.Storage](https://www.powershellgallery.com/packages/Az.Storage)
- [AzCmdlets](AzCmdlets.psm1)

This Docker image supports automated resource provisioning and application 
deployment to Azure. The [`Connect-AzAccount`][credentials] cmdlet is 
used for authentication, which requires the tentant ID and the credentials of 
an authorized service principal. An example is given in [`example.ps1`](example.ps1), 
which uses the environment variables shown in the command below to authenticate.

```
docker run --rm -it -v $PWD:/root/work --env AZ_CLIENT_ID --env AZ_CLIENT_wECRET --env AZ_TENANT_ID az -File example.ps1
```

(This command uses a 'local' build of the Docker image named `az`.)

[credentials]: https://docs.microsoft.com/en-us/powershell/module/az.accounts/Connect-AzAccount

## Contributing

### How to: update PowerShell and Git

Find the Docker tag corresponding to a newer version of PowerShell on Alpine 
Linux [here](https://hub.docker.com/_/microsoft-powershell) and update the 
`FROM` statement in the Dockerfile accordingly.

Find the current version of Git for the version of Alpine Linux used by the 
base image [here](https://pkgs.alpinelinux.org/packages), and update the 
corresponding `apk add` command in the Dockerfile accordingly.

After building the local Docker image run it to check the PowerShell and Git 
versions:

```
docker run --rm -it az -Version
docker run --rm -it az -Command "git --version"
```

### How to: update Azure PowerShell

Check the latest version of the [`Az`](https://www.powershellgallery.com/packages/Az) 
module and check its dependencies for updates of the PowerShell modules that 
are installed and update the `-RequiredVersion` argument in the corresponding 
`Install-Module` commands in the Dockerfile accordingly.

After building the local Docker image run it to check the Azure PowerShell 
module works:

```
docker run --rm -it az -Command "Get-AzEnvironment"
```
