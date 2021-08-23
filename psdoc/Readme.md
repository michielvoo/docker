# PSDoc

PowerShell and platyPS, for generating PowerShell documentation

The following PowerShell modules are installed:

- [platyPS](https://www.powershellgallery.com/packages/platyPS)

## Usage

(All example commands assume a 'local' build of the Docker image is available.)

This Docker image can be used to generate Markdown documentation for PowerShell 
modules. A directory containing PowerShell modules should be mounted in the 
working directory of the Docker container. The container executes the 
`New-MarkdownHelp` cmdlet and passes all command-line arguments to it. The 
`-Module` argument will be used to import the module. To ensure consistent 
documentation the `-OutputFolder` argument will be used to delete existing 
documentation before generating new documentation.

```
docker run --rm -it -v $PWD:/root/work psdoc -Module "Example" -OutputFolder ./docs -NoMetadata
```

## Contributing

### How to: update PowerShell

Find the Docker tag corresponding to a newer version of PowerShell on Alpine 
Linux [here](https://hub.docker.com/_/microsoft-powershell) and update the 
`FROM` statement in the Dockerfile accordingly.

After building the local Docker image run it to check the PowerShell version:

```
docker run --rm -it --entrypoint pwsh psdoc -Version
```

(Notice that this command overrides the entrypoint of the image.)

### How to: update platyPS

Find the latest version of the PowerShell modules that are installed and update 
the `-RequiredVersion` argument in the corresponding `Install-Module` commands 
in the Dockerfile accordingly.

```
docker run --rm -it --entrypoint pwsh psdoc -Command "Get-Module"
```
