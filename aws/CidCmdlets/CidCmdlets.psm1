. $PSScriptRoot/CidContext.ps1
. $PSScriptRoot/Logging.ps1

Set-Variable -Name "CidContext" -Value "test" -Option "Constant"
Export-ModuleMember -Variable "CidContext"
