FROM mcr.microsoft.com/powershell:7.1.3-alpine-3.12-20210603

LABEL org.opencontainers.image.title="AWS"
LABEL org.opencontainers.image.description="AWS Tools for PowerShell and Git on Alpine Linux, for provisioning AWS resources and deploying applications to AWS"

ENV POWERSHELL_TELEMETRY_OPTOUT=1

SHELL ["pwsh", "-Command"]

COPY AwsCmdlets /usr/local/share/powershell/Modules/AwsCmdlets
COPY CidCmdlets /usr/local/share/powershell/Modules/CidCmdlets
RUN Test-ModuleManifest -Path /usr/local/share/powershell/Modules/AwsCmdlets/AwsCmdlets.psd1 \
    && Test-ModuleManifest -Path /usr/local/share/powershell/Modules/CidCmdlets/CidCmdlets.psd1

RUN apk update --no-cache \
    && apk add git=2.26.3-r0 --no-cache \
    && Set-PSRepository -Name PSGallery -InstallationPolicy Trusted \
    && Install-Module -Confirm:$False -Scope AllUsers -Name AWS.Tools.Installer -RequiredVersion 1.0.2.1 \
    && Install-AWSToolsModule -Confirm:$False -Scope AllUsers -Name AWS.Tools.CloudFormation -RequiredVersion 4.1.14.0 \
    && Install-AWSToolsModule -Confirm:$False -Scope AllUsers -Name AWS.Tools.CloudFront -RequiredVersion 4.1.14.0 \
    && New-Item -Force -ItemType File -Path $Profile \
    && Write-Output "Import-Module AWS.Tools.CloudFormation" | Out-File -Append -FilePath $Profile \
    && Write-Output "Import-Module AWS.Tools.CloudFront" | Out-File -Append -FilePath $Profile \
    && Write-Output "Import-Module AWS.Tools.Installer" | Out-File -Append -FilePath $Profile \
    && Write-Output "Import-Module AwsCmdlets" | Out-File -Append -FilePath $Profile \
    && Write-Output "Import-Module CidCmdlets" | Out-File -Append -FilePath $Profile

WORKDIR /root/work

ENTRYPOINT ["pwsh", "-NoLogo"]
