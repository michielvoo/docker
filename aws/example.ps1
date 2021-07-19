Set-AWSCredential -AccessKey $Env:AWS_ACCESS_KEY -SecretKey $Env:AWS_SECRET_KEY -StoreAs default
Set-DefaultAWSRegion -Region $Env:AWS_REGION
Get-CFNStack