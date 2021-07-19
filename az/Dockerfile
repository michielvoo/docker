FROM mcr.microsoft.com/powershell:7.1.3-alpine-3.12-20210603

LABEL org.opencontainers.image.title="Azure PowerShell on Alpine Linux"
LABEL org.opencontainers.image.description="Azure PowerShell on Alpine Linux, for provisioning Azure resources"

RUN pwsh -Command "Set-PSRepository -Name PSGallery -InstallationPolicy 'Trusted'" \
    && pwsh -Command "Install-Module -Confirm:\$False -Scope AllUsers -Name Az.Accounts -RequiredVersion 2.5.1" \
    && pwsh -Command "Install-Module -Confirm:\$False -Scope AllUsers -Name Az.Functions -RequiredVersion 3.1.0" \
    && pwsh -Command "Install-Module -Confirm:\$False -Scope AllUsers -Name Az.Resources -RequiredVersion 4.2.0" \
    && pwsh -Command "Install-Module -Confirm:\$False -Scope AllUsers -Name Az.Storage -RequiredVersion 3.9.0" \
    && pwsh -Command "New-Item -Force -ItemType File -Path \$Profile" \
    && pwsh -Command "Write-Output 'Import-Module Az.Accounts' | Out-File -Append -FilePath \$Profile" \
    && pwsh -Command "Write-Output 'Import-Module Az.Functions' | Out-File -Append -FilePath \$Profile" \
    && pwsh -Command "Write-Output 'Import-Module Az.Resources' | Out-File -Append -FilePath \$Profile" \
    && pwsh -Command "Write-Output 'Import-Module Az.Storage' | Out-File -Append -FilePath \$Profile"

WORKDIR /root/work

ENTRYPOINT ["pwsh"]
