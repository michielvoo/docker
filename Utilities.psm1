# Utilities for use in Pester tests, Visual Studio Code tasks, and GitHub workflows

function Get-DockerName {
    param (
        [string]$Registry,
        [string]$Namespace,
        [string]$Repository
    )

    $array = @($Registry, $Namespace, $Repository) | Where-Object { $_ }

    [string]::Join("/", $array)
}

function Get-DockerNamespace {
    param (
        [string]$Directory
    )

    $relativePath = [IO.Path]::GetRelativePath($PSScriptRoot, (Split-Path $Directory -Parent))

    if ($relativePath -eq ".") {
        return $null
    }

    return $relativePath
}

function Get-DockerRegistry {
    if ($Env:GITHUB_REPOSITORY_OWNER) {
        $tenant = $Env:GITHUB_REPOSITORY_OWNER
    }
    else {
        $tenant = Split-Path -Leaf (Split-Path $PSScriptRoot -Parent)
    }

    return "docker.io/$tenant"
}

function Get-DockerMetadata {
    # Gets all the data needed to build a (multi-platform) Docker image
    param (
        [string] $dockerfileOrName
    )

    $leaf = Split-Path $dockerfileOrName -Leaf

    $isAbsolute = [IO.Path]::IsPathRooted($dockerfileOrName)
    $isRelative = -not $isAbsolute

    if ($isAbsolute) { # Value should be the path of a currently opened Dockerfile
        $extension = [IO.Path]::GetExtension($dockerfileOrName)
        $isDockerfile = $isAbsolute -and ($leaf -eq "Dockerfile" -or $extension -eq ".Dockerfile")

        if (-not $isDockerfile) {
            Throw "Expected path to " +
                "a file named 'Dockerfile' or " +
                "a file with extension '.Dockerfile' " +
                "but got path to $leaf"
        }

        $directory = Split-Path $dockerfileOrName -Parent
        $dockerfile = $dockerfileOrName
    }

    if ($isRelative) { # Value should be the relative (to the Git working directory) path of a directory containing a Dockerfile
        $directory = "$PSScriptRoot/$dockerfileOrName"
        $dockerfile = "$directory/Dockerfile"

        if (-not (Test-Path $dockerfile)) {
            $dockerfile = "$directory/$leaf.Dockerfile"
            Write-Warning $dockerfile
        }
    }

    # Exit when path does not exist

    if (-not (Test-Path $dockerfile)) {
        Throw "File or directory not found ($dockerfile)"
    }

    # Exit when path is not a file

    if ((Get-Item $dockerfile).PSIsContainer) {
        Throw "Expected file but found directory ($dockerfile)"
    }

    # Read build metadata from .psd1 file

    $metadataFile = ($dockerfile -replace "\.Dockerfile$") + ".psd1" 
    if (-not (Test-Path $metadataFile) -or (Get-Item $metadataFile).PSIsContainer) {
        Throw "File not found ($metadataFile)"
    }

    # Read metadata
    $metadata = Import-PowerShellDataFile $metadataFile
    if (-not $metadata.Labels) {
        $metadata.Labels = @{}
    }

    # Set paths
    $metadata.Directory = "$directory"
    $metadata.Dockerfile = "$dockerfile"

    # Set name components
    $metadata.Namespace = Get-DockerNamespace $directory
    $metadata.Registry = Get-DockerRegistry
    $metadata.Repository = Split-Path $directory -Leaf
    $metadata.Name = Get-DockerName $metadata.Registry $metadata.Namespace $metadata.Repository

    # Add labels
    # Use BUILDX_GIT_LABELS=full to get OCI labels

    return $metadata
}

Export-ModuleMember Get-DockerMetadata
