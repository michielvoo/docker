# Pester

Pester, for running automated PowerShell tests

The following PowerShell modules are installed:

- [Pester](https://www.powershellgallery.com/packages/Pester)

This Docker image supports execution of Pester tests. A directory containing 
PowerShell scripts and their accompanying tests should be mounted in the 
working directory of the Docker container. The container executes the 
`Invoke-Pester` cmdlet and passes all arguments to it. Tests will automatically 
be discovered, and arguments such as `-Tag` can be used to filter the tests.

```
docker run --rm -it -v $PWD:/root/work pester -Tag unit
```

(This command uses a 'local' build of the Docker image named `pester`.)

## Contributing

### How to: update PowerShell

Find the Docker tag corresponding to a newer version of PowerShell on Alpine 
Linux [here](https://hub.docker.com/_/microsoft-powershell) and update the 
`FROM` statement in the Dockerfile accordingly.

After building the local Docker image run it to check the PowerShell version:

```
docker run --rm -it --entrypoint pwsh pester -Version
```

### How to: update Pester

Find the latest version of the PowerShell modules that are installed and update 
the `-RequiredVersion` argument in the corresponding `Install-Module` commands 
in the Dockerfile accordingly.
