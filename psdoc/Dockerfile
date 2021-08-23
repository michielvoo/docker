FROM mcr.microsoft.com/powershell:7.1.3-alpine-3.12-20210603

LABEL org.opencontainers.image.title="PSDoc"
LABEL org.opencontainers.image.description="PSDoc, for generating PowerShell documentation"

ENV POWERSHELL_TELEMETRY_OPTOUT=1

SHELL ["pwsh", "-Command"]

RUN Set-PSRepository -Name PSGallery -InstallationPolicy Trusted \
    && Install-Module -AllowPrerelease -Confirm:$False -Scope AllUsers -Name platyPS -RequiredVersion 2.0.0-preview1

COPY Profile.ps1 /root/.config/powershell/Microsoft.PowerShell_profile.ps1

COPY docker-entrypoint.ps1 /usr/bin
RUN chmod +x /usr/bin/docker-entrypoint.ps1

WORKDIR /root/work

ENTRYPOINT ["pwsh", "-File", "/usr/bin/docker-entrypoint.ps1"]
