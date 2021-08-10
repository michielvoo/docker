Import-Module AWS.Tools.CloudFormation
Import-Module AWS.Tools.CloudFront
Import-Module AWS.Tools.Installer
Import-Module AWS.Tools.Route53
Import-Module AWS.Tools.S3
Import-Module AwsCmdlets
Import-Module CidCmdlets

If ((Test-Path -Path "Env:AWS_ACCESS_KEY_ID") -and (Test-Path -Path "Env:AWS_SECRET_ACCESS_KEY"))
{
    Set-AWSCredential -StoreAs "default" -AccessKey $Env:AWS_ACCESS_KEY_ID -SecretKey $Env:AWS_SECRET_ACCESS_KEY
}

If (Test-Path -Path "Env:AWS_DEFAULT_REGION")
{
    Set-DefaultAWSRegion -Region $Env:AWS_DEFAULT_REGION
}

$OriginalPrompt = (Get-Command Prompt).ScriptBlock
Function Prompt
{
    (Invoke-Command $OriginalPrompt) -replace 'PS','AWS PS'
}
