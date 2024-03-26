# Utilities for use in Pester tests, Visual Studio Code tasks, and GitHub workflows

function Read-DockerMetadata {
    param (
        [string]$Dockerfile
    )

    $metadataFile = ($dockerfile -replace "\.Dockerfile$") + ".psd1" 
    if (-not (Test-Path $metadataFile) -or (Get-Item $metadataFile).PSIsContainer) {
        Throw "Metadata file '$(Split-Path $metadataFile -Leaf)' not found"
    }

    # Read metadata
    $metadata = Import-PowerShellDataFile $metadataFile
    if (-not $metadata.Labels) {
        $metadata.Labels = @{}
    }

    if (-not $metadata.Platforms) {
        throw "No platform(s) specified in metadata"
    }

    return $metadata
}

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
        return ""
    }

    return $relativePath
}

function Get-DockerNamespaceAndRepository {
    param (
        [string]$Namespace,
        [string]$Repository
    )

    $array = @($Namespace, $Repository) | Where-Object { $_ }

    [string]::Join("/", $array)
}

function Get-DockerRegistry {
    if (-not $Env:DOCKER_REGISTRY) {
        throw "DOCKER_REGISTRY environment variable is not set"
    }

    return $Env:DOCKER_REGISTRY
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
                "but got path to '$leaf'"
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
        Throw "File or directory '$dockerfile' not found"
    }

    # Exit when path is not a file

    if ((Get-Item $dockerfile).PSIsContainer) {
        Throw "Expected file but found directory '$dockerfile'"
    }

    # Read metadata from PowerShell data file
    $metadata = Read-DockerMetadata $dockerfile

    # Set paths
    $metadata.Directory = "$directory"
    $metadata.Dockerfile = "$dockerfile"

    # Set name components
    $metadata.Namespace = Get-DockerNamespace $directory
    $metadata.Registry = Get-DockerRegistry
    $metadata.Repository = Split-Path $directory -Leaf

    # Set concatenated name values
    $metadata.NamespaceAndRepository = Get-DockerNamespaceAndRepository $metadata.Namespace $metadata.Repository
    $metadata.Name = Get-DockerName $metadata.Registry $metadata.Namespace $metadata.Repository

    # Add labels
    # Use BUILDX_GIT_LABELS=full to get OCI labels

    return $metadata
}

function Get-DockerTestCases {
    # Gets an array of hashtable objects, one for each target platform
    param (
        [string] $dockerfileOrName
    )

    $metadata = Get-DockerMetadata $dockerfileOrName

    $testCases = $metadata.Platforms | ForEach-Object {@{
        Metadata = $metadata
        Platform = $_
    }}

    return $testCases
}

Export-ModuleMember Get-DockerMetadata
Export-ModuleMember Get-DockerTestCases
