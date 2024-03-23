# syntax=docker/dockerfile:1

FROM mcr.microsoft.com/powershell:lts-7.2-alpine-3.17

ENV POWERSHELL_TELEMETRY_OPTOUT=1

SHELL ["pwsh", "-Command"]

RUN apk update --no-cache \
    && apk add git=~2.38 --no-cache \
    && Set-PSRepository -Name PSGallery -InstallationPolicy Trusted \
    && Install-Module -Confirm:$False -Scope AllUsers -Name AWS.Tools.Installer -RequiredVersion 1.0.2.5 \
    && Install-AWSToolsModule -Confirm:$False -Scope AllUsers -Name AWS.Tools.CloudFormation -RequiredVersion 4.1.538 \
    && Install-AWSToolsModule -Confirm:$False -Scope AllUsers -Name AWS.Tools.CloudFront -RequiredVersion 4.1.538 \
    && Install-AWSToolsModule -Confirm:$False -Scope AllUsers -Name AWS.Tools.Route53 -RequiredVersion 4.1.538 \
    && Install-AWSToolsModule -Confirm:$False -Scope AllUsers -Name AWS.Tools.S3 -RequiredVersion 4.1.538

COPY Profile.ps1 /root/.config/powershell/Microsoft.PowerShell_profile.ps1

COPY AwsCmdlets /usr/local/share/powershell/Modules/AwsCmdlets
COPY CidCmdlets /usr/local/share/powershell/Modules/CidCmdlets
RUN Test-ModuleManifest -Path /usr/local/share/powershell/Modules/AwsCmdlets/AwsCmdlets.psd1 \
    && Test-ModuleManifest -Path /usr/local/share/powershell/Modules/CidCmdlets/CidCmdlets.psd1

WORKDIR /root/work

ENTRYPOINT ["pwsh", "-NoLogo"]
