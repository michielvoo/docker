$Username = $Env:AZ_CLIENT_ID
$Password = ConvertTo-SecureString $Env:AZ_CLIENT_SECRET -AsPlainText –Force
$Credential = New-Object -TypeName PSCredential –ArgumentList $Username, $Password
Connect-AzAccount -ServicePrincipal –TenantId $Env:AZ_TENANT_ID -Credential $Credential
Get-AzContext
