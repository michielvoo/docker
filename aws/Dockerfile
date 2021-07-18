FROM mcr.microsoft.com/powershell:7.1.3-alpine-3.12-20210603

LABEL org.opencontainers.image.title="AWS Tools for PowerShell"
LABEL org.opencontainers.image.description="AWS Tools for PowerShell on Alpine Linux, for provisioning AWS resources"

RUN pwsh -Command "Set-PSRepository -Name PSGallery -InstallationPolicy 'Trusted'" \
    && pwsh -Command "Install-Module -Confirm:\$False -Scope AllUsers -Name AWS.Tools.Installer -RequiredVersion 1.0.2.1" \
    && pwsh -Command "Install-AWSToolsModule -Confirm:\$False -Scope AllUsers -Name AWS.Tools.CloudFormation -RequiredVersion 4.1.14.0" \
    && pwsh -Command "Install-AWSToolsModule -Confirm:\$False -Scope AllUsers -Name AWS.Tools.CloudFront -RequiredVersion 4.1.14.0" \
    && pwsh -Command "New-Item -Force -ItemType File -Path \$Profile" \
    && pwsh -Command "Write-Output 'Import-Module AWS.Tools.CloudFormation' | Out-File -Append -FilePath \$Profile" \
    && pwsh -Command "Write-Output 'Import-Module AWS.Tools.CloudFront' | Out-File -Append -FilePath \$Profile" \
    && pwsh -Command "Write-Output 'Import-Module AWS.Tools.Installer' | Out-File -Append -FilePath \$Profile"

WORKDIR /src

ENTRYPOINT ["pwsh"]
