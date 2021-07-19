# AWS Tools for PowerShell

AWS Tools for PowerShell on Alpine Linux, for provisioning AWS resources

The following PowerShell modules are installed:

- [AWS.Tools.CloudFormation](https://www.powershellgallery.com/packages/AWS.Tools.CloudFormation)
- [AWS.Tools.CloudFront](https://www.powershellgallery.com/packages/AWS.Tools.CloudFront)
- [AWS.Tools.Installer](https://www.powershellgallery.com/packages/AWS.Tools.Installer)

This Docker image supports automated resource provisioning and application 
deployment to AWS. The [`Set-AWSCredential`][credentials] cmdlet is 
used for authentication, which requires the access key and secret key of an 
authorized IAM user. The [`Set-DefaultAWSRegion`][region] cmdlet can be used to 
set a default region for all commands.

An example is given in [`example.ps1`](example.ps1), which uses the environment 
variables shown in the command below to authenticate and to set a default 
region.

```
docker run --rm -it -v $PWD:/root/work --env AWS_ACCESS_KEY --env AWS_REGION --env AWS_SECRET_KEY aws -File example.ps1
```

[credentials]: https://docs.aws.amazon.com/powershell/latest/userguide/specifying-your-aws-credentials.html
[region]: https://docs.aws.amazon.com/powershell/latest/userguide/pstools-installing-specifying-region.html

## Contributing

### How to: update PowerShell

Find the Docker tag corresponding to a newer version of PowerShell on Alpine 
Linux [here](https://hub.docker.com/_/microsoft-powershell) and update the 
`FROM` statement in the Dockerfile accordingly.

After building the local Docker image run it to check the PowerShell version:

```
docker run --rm -it aws -Version
```

### How to: update AWS Tools for PowerShell

Find the latest version of the PowerShell modules that are installed and update 
the `-RequiredVersion` argument in the corresponding `Install-Module` commands 
in the Dockerfile accordingly.

### How to: test AWS Tools for PowerShell

```
docker run --rm -it aws -Command Get-AWSPowerShellVersion
```