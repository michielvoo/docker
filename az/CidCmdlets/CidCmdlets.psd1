@{
    CmdletsToExport = @("*")
    Description = "Contains cmdlets targeted at CI/CD scripts."
    GUID = "dfc5beea-1fe2-4787-b844-c2e708a313b3"
    ModuleVersion = "0.1"
    NestedModules = @(
        "./Use-CidGroup.ps1"
    )
    ScriptsToProcess = @(
        "./Import.ps1"
    )
}
