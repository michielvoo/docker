. $PSScriptRoot/CidContext.ps1
. $PSScriptRoot/Logging.ps1

Set-Variable -Name "CidContext" -Value (Get-CidContext) -Option "Constant"
Export-ModuleMember -Variable "CidContext"
