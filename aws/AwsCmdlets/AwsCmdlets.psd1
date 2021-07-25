@{
    CmdletsToExport = @("*")
    Description = "Contains cmdlets that wrap AWS Tools for PowerShell cmdlets."
    GUID = "80cc5a9f-52fb-4b66-8270-f32893ba253e"
    ModuleVersion = "0.1"
    NestedModules = @(
      "./ConvertTo-CFNParameters.ps1"
      "./ConvertTo-CFNTags.ps1"
      "./Deploy-CFNStack.ps1"
    )
}
