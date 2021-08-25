# pwsh

pwsh, for running a PowerShell command or script

The following PowerShell modules are installed:

- [PSScriptAnalyzer](https://www.powershellgallery.com/packages/PSScriptAnalyzer)

## Usage

(All example commands assume a 'local' build of the Docker image is available.)

This Docker image supports execution of a PowerShell command or script. The 
container's entrypoint is `pwsh`. To execute a command pass the `-Command` 
argument. To execute a script pass the `-File` argument. A directory containing 
the PowerShell script should be mounted in the working directory of the Docker 
container.

```
docker run --rm -it pwsh -Command "Write-Host Hello"
docker run --rm -it -v $PWD:/root/work pwsh -File example.ps1
```

## Contributing

### How to: update PowerShell

Find the Docker tag corresponding to a newer version of PowerShell on Alpine 
Linux [here](https://hub.docker.com/_/microsoft-powershell) and update the 
`FROM` statement in the Dockerfile accordingly.

After building the local Docker image run it to check the PowerShell version:

```
docker run --rm -it pwsh -Version
```

### How to: update PowerShell modules

Find the latest version of the PowerShell modules that are installed and update 
the `-RequiredVersion` argument in the corresponding `Install-Module` commands 
in the Dockerfile accordingly.

```
docker run --rm -it pwsh -Command "Get-Module"
```
