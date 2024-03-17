# pester

Pester, for running automated PowerShell tests

The following PowerShell modules are installed:

- [Pester](https://www.powershellgallery.com/packages/Pester)

## Usage

This Docker image supports execution of Pester tests. A directory containing 
PowerShell scripts and their accompanying tests should be mounted in the 
working directory of the Docker container. The container executes the 
`Invoke-Pester` cmdlet and passes all command-line arguments to it. For the 
value of the `-Configuration` argument a JSON formatted string can be used.

```
docker run --rm -it -v $PWD:/root/work pester -Output Detailed
docker run --rm -it -v $PWD:/root/work pester -Configuration "{ \"Output\": { \"Verbosity\": \"Detailed\" } }"
```
