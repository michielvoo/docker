FROM mcr.microsoft.com/powershell:lts-7.2-debian-11

LABEL org.opencontainers.image.title="ci/powershell"
LABEL org.opencontainers.image.description="Docker image for continuous integration of PowerShell modules"

ENV POWERSHELL_TELEMETRY_OPTOUT=1
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1

SHELL ["pwsh", "-Command"]

RUN \
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted \
&& Install-Module -Confirm:$false -Scope AllUsers -Name Pester \
&& Install-Module -Confirm:$false -Scope AllUsers -Name PSScriptAnalyzer

RUN \
apt-get update \
&& apt-get install -yq bash curl \
&& apt-get clean \
&& curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin -InstallDir /usr/share/dotnet \
&& ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

COPY Profile.ps1 /root/.config/powershell/Microsoft.PowerShell_profile.ps1
