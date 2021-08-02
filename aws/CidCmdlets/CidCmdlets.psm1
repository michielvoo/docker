. $PSScriptRoot/CidContext.ps1
. $PSScriptRoot/Logging.ps1

Set-Variable -Name "CidContext" -Value (Get-CidContext) -Option "Constant"
Export-ModuleMember -Variable "CidContext"

If ((Test-Path -Path "Env:AWS_ACCESS_KEY_ID") -and (Test-Path -Path "Env:AWS_SECRET_ACCESS_KEY"))
{
    Write-Host "Saving AWS credentials to persistent store"
    Set-AWSCredential -StoreAs "default" -AccessKey $Env:AWS_ACCESS_KEY_ID -SecretKey $Env:AWS_SECRET_ACCESS_KEY
}

If (Test-Path -Path "Env:AWS_DEFAULT_REGION")
{
    Write-Host "Setting default AWS region into the shell environment"
    Set-DefaultAWSRegion -Region $Env:AWS_DEFAULT_REGION
}

$CidContext |
    Format-Table -AutoSize -HideTableHeaders |
    Out-String -Stream |
    Where-Object { $_ -ne "" } |
    ForEach-Object { Write-Host $_ }
