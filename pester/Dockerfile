FROM mcr.microsoft.com/powershell:7.1.3-alpine-3.12-20210603

LABEL org.opencontainers.image.title="Pester"
LABEL org.opencontainers.image.description="Pester, for running automated PowerShell tests"

ENV POWERSHELL_TELEMETRY_OPTOUT=1

SHELL ["pwsh", "-Command"]

RUN Set-PSRepository -Name PSGallery -InstallationPolicy Trusted \
    && Install-Module -Confirm:$False -Scope AllUsers -Name Pester -RequiredVersion 5.2.2 \
    && New-Item -Force -ItemType File -Path $Profile \
    && Write-Output "Import-Module Pester" | Out-File -Append -FilePath $Profile

COPY docker-entrypoint.ps1 /usr/bin
RUN chmod +x /usr/bin/docker-entrypoint.ps1

WORKDIR /root/work

ENTRYPOINT ["/usr/bin/docker-entrypoint.ps1"]
