FROM mcr.microsoft.com/powershell:lts-7.2-alpine-3.17

LABEL org.opencontainers.image.title="pwsh"
LABEL org.opencontainers.image.description="pwsh, for running a PowerShell command or script"

ENV POWERSHELL_TELEMETRY_OPTOUT=1
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1

SHELL ["pwsh", "-Command"]

RUN Set-PSRepository -Name PSGallery -InstallationPolicy Trusted \
    && Install-Module -Confirm:$False -Scope AllUsers -Name PSScriptAnalyzer -RequiredVersion 1.20.0

RUN apk add bash curl \
    && curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin -InstallDir /usr/share/dotnet \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

COPY Profile.ps1 /root/.config/powershell/Microsoft.PowerShell_profile.ps1

WORKDIR /root/work

ENTRYPOINT ["pwsh"]
