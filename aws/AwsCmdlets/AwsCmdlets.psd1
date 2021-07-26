@{
    CmdletsToExport = @()
    Description = "Contains cmdlets that wrap AWS Tools for PowerShell cmdlets."
    FunctionsToExport = @(
        "ConvertTo-CFNParameters"
        "ConvertTo-CFNTags"
        "Deploy-CFNStack"
    )
    GUID = "80cc5a9f-52fb-4b66-8270-f32893ba253e"
    ModuleVersion = "0.1"
    RootModule = "AwsCmdlets.psm1"
}
