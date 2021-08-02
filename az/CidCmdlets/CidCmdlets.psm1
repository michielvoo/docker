. $PSScriptRoot/CidContext.ps1
. $PSScriptRoot/Logging.ps1

Set-Variable -Name "CidContext" -Value (Get-CidContext) -Option "Constant"
Export-ModuleMember -Variable "CidContext"

$CidContext |
    Format-Table -AutoSize -HideTableHeaders |
    Out-String -Stream |
    Where-Object { $_ -ne "" } |
    ForEach-Object { Write-Host $_ }
