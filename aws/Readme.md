# AWS Tools for PowerShell

AWS Tools for PowerShell and Git on Alpine Linux, for provisioning AWS resources

The following PowerShell modules are installed:

- [AWS.Tools.CloudFormation](https://www.powershellgallery.com/packages/AWS.Tools.CloudFormation)
- [AWS.Tools.CloudFront](https://www.powershellgallery.com/packages/AWS.Tools.CloudFront)
- [AWS.Tools.Installer](https://www.powershellgallery.com/packages/AWS.Tools.Installer)
- [AwsCmdlets](AwsCmdlets)
- [CidCmdlets](CidCmdlets)

## Usage

(All example commands assume a 'local' build of the Docker image is available.)

This Docker image supports automated resource provisioning and application 
deployment to AWS, by running a PowerShell script inside an optimized Docker 
container.

```
docker run --rm -it -v $PWD:/root/work aws -File deploy.ps1
```

When PowerShell starts and the environment variables `AWS_ACCESS_KEY_ID` and 
`AWS_SECRET_ACCESS_KEY` are present, they are saved as AWS credentials to the 
persistent store (as the `default` profile). When the `AWS_DEFAULT_REGION` 
environment variable is present then a default AWS region is also set into the 
shell variable `$StoredAWSRegion` (see <Profile.ps1>).

An example invocation that takes advantage of this is given below:

```
docker run --rm -it -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION aws -Command "Get-CFNStack"
```

The global constant `$CidContext` provides default parameter values for several 
cmdlets, and is initialized based on the SCM system in use (e.g. Git) and the 
execution environment (e.g. GitHub Actions, or Azure Pipelines). During 
initialization the following environment variables, when set, are used to 
override the values:

- `CID_ARTIFACTS_PATH` (the path used as output path for build commands)
- `CID_COMMIT` (the identifier of the commit that is checked out)
- `CID_DEPLOYMENT` (the unique name of the deployment, typically a concatenation of several other values)
- `CID_ENVIRONMENT` (the environment to which an application is being deployed, e.g. `prd`)
- `CID_NAME` (the name of the unit that is being deployed or published)
- `CID_RUN` (the ID of the run, also known as the build or the action, depending on the execution environment's nomenclature)
- `CID_RUNNER` (e.g. `gh` for GitHub Actions, or `tf` for Azure Pipelines)
- `CID_SCM` (e.g. `git`)

[credentials]: https://docs.aws.amazon.com/powershell/latest/userguide/specifying-your-aws-credentials.html
[region]: https://docs.aws.amazon.com/powershell/latest/userguide/pstools-installing-specifying-region.html

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
docker run --rm -it aws -Version
docker run --rm -it aws -Command "git --version"
```

### How to: update AWS Tools for PowerShell

Find the latest version of the PowerShell modules that are installed and update 
the `-RequiredVersion` argument in the corresponding `Install-Module` commands 
in the Dockerfile accordingly.

After building the local Docker image run it to check the AWS Tools for 
PowerShell version:

```
docker run --rm -it aws -Command "Get-AWSPowerShellVersion"
```
