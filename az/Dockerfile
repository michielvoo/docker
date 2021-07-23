FROM mcr.microsoft.com/powershell:7.1.3-alpine-3.12-20210603

LABEL org.opencontainers.image.title="Azure"
LABEL org.opencontainers.image.description="Azure PowerShell and Git on Alpine Linux, for provisioning Azure resources and deploying applications to Azure"

RUN apk update --no-cache \
    && apk add git=2.26.3-r0 --no-cache \
    && pwsh -Command "Set-PSRepository -Name PSGallery -InstallationPolicy 'Trusted'" \
    && pwsh -Command "Install-Module -Confirm:\$False -Scope AllUsers -Name Az.Accounts -RequiredVersion 2.5.1" \
    && pwsh -Command "Install-Module -Confirm:\$False -Scope AllUsers -Name Az.Functions -RequiredVersion 3.1.0" \
    && pwsh -Command "Install-Module -Confirm:\$False -Scope AllUsers -Name Az.Resources -RequiredVersion 4.2.0" \
    && pwsh -Command "Install-Module -Confirm:\$False -Scope AllUsers -Name Az.Storage -RequiredVersion 3.9.0" \
    && pwsh -Command "New-Item -Force -ItemType File -Path \$Profile" \
    && pwsh -Command "Write-Output 'Import-Module Az.Accounts' | Out-File -Append -FilePath \$Profile" \
    && pwsh -Command "Write-Output 'Import-Module Az.Functions' | Out-File -Append -FilePath \$Profile" \
    && pwsh -Command "Write-Output 'Import-Module Az.Resources' | Out-File -Append -FilePath \$Profile" \
    && pwsh -Command "Write-Output 'Import-Module Az.Storage' | Out-File -Append -FilePath \$Profile" \
    && pwsh -Command "Disable-AzDataCollection" \
    && mkdir -pv /usr/local/share/powershell/Modules/AzCmdlets

COPY AzCmdlets.psm1 /usr/local/share/powershell/Modules/AzCmdlets

ENV POWERSHELL_TELEMETRY_OPTOUT=1

WORKDIR /root/work

ENTRYPOINT ["pwsh", "-NoLogo"]
