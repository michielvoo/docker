FROM mcr.microsoft.com/powershell:7.1.3-alpine-3.12-20210603

LABEL org.opencontainers.image.title="Azure"
LABEL org.opencontainers.image.description="Azure PowerShell and Git on Alpine Linux, for provisioning Azure resources and deploying applications to Azure"

ENV POWERSHELL_TELEMETRY_OPTOUT=1

SHELL ["pwsh", "-Command"]

RUN apk update --no-cache \
    && apk add git=2.26.3-r0 --no-cache \
    && Set-PSRepository -Name PSGallery -InstallationPolicy Trusted \
    && Install-Module -Confirm:$False -Scope AllUsers -Name Az.Accounts -RequiredVersion 2.5.1 \
    && Install-Module -Confirm:$False -Scope AllUsers -Name Az.Functions -RequiredVersion 3.1.0 \
    && Install-Module -Confirm:$False -Scope AllUsers -Name Az.Resources -RequiredVersion 4.2.0 \
    && Install-Module -Confirm:$False -Scope AllUsers -Name Az.Storage -RequiredVersion 3.9.0 \
    && New-Item -Force -ItemType File -Path $Profile \
    && Write-Output "Import-Module Az.Accounts" | Out-File -Append -FilePath $Profile \
    && Write-Output "Import-Module Az.Functions" | Out-File -Append -FilePath $Profile \
    && Write-Output "Import-Module Az.Resources" | Out-File -Append -FilePath $Profile \
    && Write-Output "Import-Module Az.Storage" | Out-File -Append -FilePath $Profile \
    && Write-Output "Import-Module AzCmdlets" | Out-File -Append -FilePath $Profile \
    && Write-Output "Import-Module CidCmdlets" | Out-File -Append -FilePath $Profile \
    && Write-Output "If ((Test-Path -Path 'Env:AZ_CLIENT_ID') -and (Test-Path -Path 'Env:AZ_CLIENT_SECRET') -and (Test-Path -Path 'Env:AZ_TENANT_ID'))" | Out-File -Append -FilePath $Profile \
    && Write-Output "{" | Out-File -Append -FilePath $Profile \
    && Write-Output "    `$Username = `$Env:AZ_CLIENT_ID" | Out-File -Append -FilePath $Profile \
    && Write-Output "    `$Password = ConvertTo-SecureString `$Env:AZ_CLIENT_SECRET -AsPlainText –Force" | Out-File -Append -FilePath $Profile \
    && Write-Output "    `$Password = ConvertTo-SecureString `$Env:AZ_CLIENT_SECRET -AsPlainText –Force" | Out-File -Append -FilePath $Profile \
    && Write-Output "    `$Credential = New-Object -TypeName PSCredential –ArgumentList `$Username, `$Password" | Out-File -Append -FilePath $Profile \
    && Write-Output "    Connect-AzAccount -ServicePrincipal –TenantId `$Env:AZ_TENANT_ID -Credential `$Credential" | Out-File -Append -FilePath $Profile \
    && Write-Output "}" | Out-File -Append -FilePath $Profile \
    && Write-Output "`$OriginalPrompt = (Get-Command Prompt).ScriptBlock" | Out-File -Append -FilePath $Profile \
    && Write-Output "Function Prompt { (Invoke-Command `$OriginalPrompt) -replace 'PS','Azure PS' }" | Out-File -Append -FilePath $Profile \
    && Disable-AzDataCollection

COPY AzCmdlets /usr/local/share/powershell/Modules/AzCmdlets
COPY CidCmdlets /usr/local/share/powershell/Modules/CidCmdlets
RUN Test-ModuleManifest -Path /usr/local/share/powershell/Modules/CidCmdlets/CidCmdlets.psd1 \
    && Test-ModuleManifest -Path /usr/local/share/powershell/Modules/AzCmdlets/AzCmdlets.psd1

WORKDIR /root/work

ENTRYPOINT ["pwsh", "-NoLogo"]
