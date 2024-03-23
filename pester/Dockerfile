# syntax=docker/dockerfile:1

FROM mcr.microsoft.com/powershell:lts-7.2-alpine-3.17

ENV POWERSHELL_TELEMETRY_OPTOUT=1

SHELL ["pwsh", "-Command"]

RUN Set-PSRepository -Name PSGallery -InstallationPolicy Trusted \
    && Install-Module -Confirm:$False -Scope AllUsers -Name Pester -RequiredVersion 5.2.2

COPY Profile.ps1 /root/.config/powershell/Microsoft.PowerShell_profile.ps1

COPY docker-entrypoint.ps1 /usr/bin
RUN chmod +x /usr/bin/docker-entrypoint.ps1

WORKDIR /root/work

ENTRYPOINT ["pwsh", "-File", "/usr/bin/docker-entrypoint.ps1"]
