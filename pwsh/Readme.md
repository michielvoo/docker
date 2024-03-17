# pwsh

pwsh, for running a PowerShell command or script

[![pwsh][badge]][workflow]

[badge]: https://github.com/michielvoo/Docker/actions/workflows/pwsh.yaml/badge.svg
[workflow]: https://github.com/michielvoo/Docker/actions/workflows/pwsh.yaml

The following PowerShell modules are installed:

- [PSScriptAnalyzer](https://www.powershellgallery.com/packages/PSScriptAnalyzer)

## Usage

This Docker image supports execution of a PowerShell command or script. The 
container's entrypoint is `pwsh`. To execute a command pass the `-Command` 
argument. To execute a script pass the `-File` argument. A directory containing 
the PowerShell script should be mounted in the working directory of the Docker 
container.

```
docker run --rm -it pwsh -Command "Write-Host Hello"
docker run --rm -it -v $PWD:/root/work pwsh -File example.ps1
```
