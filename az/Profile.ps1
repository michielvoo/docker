Import-Module Az.Accounts
Import-Module Az.Functions
Import-Module Az.Resources
Import-Module Az.Storage
Import-Module AzCmdlets
Import-Module CidCmdlets

If ((Test-Path -Path "Env:AZ_CLIENT_ID") -and (Test-Path -Path "Env:AZ_CLIENT_SECRET") -and (Test-Path -Path "Env:AZ_TENANT_ID"))
{
    $Username = $Env:AZ_CLIENT_ID
    $Password = ConvertTo-SecureString $Env:AZ_CLIENT_SECRET -AsPlainText –Force
    $Password = ConvertTo-SecureString $Env:AZ_CLIENT_SECRET -AsPlainText –Force
    $Credential = New-Object -TypeName PSCredential –ArgumentList $Username, $Password

    Connect-AzAccount -ServicePrincipal –TenantId $Env:AZ_TENANT_ID -Credential $Credential
}

$OriginalPrompt = (Get-Command Prompt).ScriptBlock
Function Prompt
{
    (Invoke-Command $OriginalPrompt) -replace "PS","Azure PS"
}
