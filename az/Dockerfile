# syntax=docker/dockerfile:1

FROM mcr.microsoft.com/powershell:lts-7.2-alpine-3.17

ENV POWERSHELL_TELEMETRY_OPTOUT=1

SHELL ["pwsh", "-Command"]

RUN apk update --no-cache \
    && apk add git=~2.38 --no-cache \
    && Set-PSRepository -Name PSGallery -InstallationPolicy Trusted \
    && Install-Module -Confirm:$False -Scope AllUsers -Name Az.Accounts -RequiredVersion 2.7.4 \
    && Install-Module -Confirm:$False -Scope AllUsers -Name Az.Functions -RequiredVersion 4.0.1 \
    && Install-Module -Confirm:$False -Scope AllUsers -Name Az.Resources -RequiredVersion 5.4.0 \
    && Install-Module -Confirm:$False -Scope AllUsers -Name Az.Storage -RequiredVersion 4.3.0 \
    && Disable-AzDataCollection

COPY Profile.ps1 /root/.config/powershell/Microsoft.PowerShell_profile.ps1

COPY AzCmdlets /usr/local/share/powershell/Modules/AzCmdlets
COPY CidCmdlets /usr/local/share/powershell/Modules/CidCmdlets
RUN Test-ModuleManifest -Path /usr/local/share/powershell/Modules/CidCmdlets/CidCmdlets.psd1 \
    && Test-ModuleManifest -Path /usr/local/share/powershell/Modules/AzCmdlets/AzCmdlets.psd1

WORKDIR /root/work

ENTRYPOINT ["pwsh", "-NoLogo"]
