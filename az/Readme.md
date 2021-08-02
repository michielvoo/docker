# Azure PowerShell

Azure PowerShell and Git on Alpine Linux, for provisioning Azure resources

The following PowerShell modules are installed:

- [Az.Accounts](https://www.powershellgallery.com/packages/Az.Accounts)
- [Az.Functions](https://www.powershellgallery.com/packages/Az.Functions)
- [Az.Resources](https://www.powershellgallery.com/packages/Az.Resources)
- [Az.Storage](https://www.powershellgallery.com/packages/Az.Storage)
- [AzCmdlets](AzCmdlets)
- [CidCmdlets](CidCmdlets)

## Usage

(All example commands assume a 'local' build of the Docker image is available.)

This Docker image supports automated resource provisioning and application 
deployment to Azure, by running a PowerShell script inside an optimized Docker 
container.

```
docker run --rm -it -v $PWD:/root/work az -File deploy.ps1
```

When PowerShell starts and the credentials of an authorized service principal 
are present in the environment variables `AZ_CLIENT_ID`, `AZ_CLIENT_SECRET`, 
and `AZ_TENANT_ID`, they are used to connect to Azure (see [Profile.ps1](Profile.ps1)).

An example invocation that takes advantage of this is given below:

```
docker run --rm -it -e AZ_CLIENT_ID -e AZ_CLIENT_SECRET -e AZ_TENANT_ID az -Command "Get-AzDefault"
```

The global constant `$CidContext` provides default parameter values for several 
cmdlets, and is initialized based on the SCM system in use (e.g. Git) and the 
execution environment (e.g. GitHub Actions, or Azure Pipelines). During 
initialization the following environment variables, when set, are used to 
override the values:

- `CID_ARTIFACTS_PATH`: the path used as output path for build commands
- `CID_COMMIT`: the identifier of the commit that is checked out
- `CID_DEPLOYMENT`: the unique name of the deployment, typically a concatenation of several other values
- `CID_ENVIRONMENT`: the environment to which an application is being deployed, e.g. `prd`
- `CID_NAME`: the name of the unit that is being deployed or published
- `CID_RUN`: the ID of the run, also known as the build or the action, depending on the execution environment's nomenclature
  - Azure DevOps (Server) Pipelines: `BUILD_BUILDID`
  - Bitbucket Pipelines: `BITBUCKET_BUILD_NUMBER`
  - GitHub Actions: `GITHUB_RUN_ID`
  - GitLab CI/CD pipelines: `CI_JOB_ID`
  - TeamCity: `BUILD_NUMBER`
- `CID_RUNNER`: the execution environment (`az`, `bit`, `gh`, `gl`, or `tc`), detection is based on `CID_RUN`
- `CID_SCM`: e.g. `git`

[credentials]: https://docs.microsoft.com/en-us/powershell/module/az.accounts/Connect-AzAccount

## Contributing

### How to: Run automated tests

```
docker run --rm -it -v $PWD:/root/work pester -Output Detailed
```

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
