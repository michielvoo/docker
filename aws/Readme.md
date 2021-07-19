# AWS Tools for PowerShell

AWS Tools for PowerShell on Alpine Linux, for provisioning AWS resources

The following PowerShell modules are installed:

- [AWS.Tools.CloudFormation](https://www.powershellgallery.com/packages/AWS.Tools.CloudFormation)
- [AWS.Tools.CloudFront](https://www.powershellgallery.com/packages/AWS.Tools.CloudFront)
- [AWS.Tools.Installer](https://www.powershellgallery.com/packages/AWS.Tools.Installer)

## How to: update PowerShell

Find the Docker tag corresponding to a newer version of PowerShell on Alpine 
Linux [here](https://hub.docker.com/_/microsoft-powershell) and update the 
`FROM` statement in the Dockerfile accordingly.

After building the local Docker image run it to check the PowerShell version:

```
docker run --rm -it aws -Version
```

## How to: update AWS Tools for PowerShell

Find the latest version of the PowerShell that are installed and update the 
 `-RequiredVersion` argument in the corresponding commands in the Dockerfile 
 accordingly.

## How to: test AWS Tools for PowerShell

Run the local Docker image to execute the `test.ps1` script, while making sure 
the required environment variables are set correctly:

```
docker run --rm -it -v $PWD:/src --env AWS_ACCESS_KEY --env AWS_REGION --env AWS_SECRET_KEY aws -File test.ps1
```
