# Utilities for use in Pester tests, Visual Studio Code tasks, and GitHub workflows

function Get-DockerRepositoryPrefix {
    $path = $PSScriptRoot
    if ($Env:GITHUB_REPOSITORY) {
        $path = $Env:GITHUB_REPOSITORY
    }

    $path = Split-Path $path -Parent

    return Split-Path $path -Leaf
}

function Get-DockerfilePath {
    param (
        [string]$fileOrName
    )

    if ([System.IO.Path]::IsPathRooted($fileOrName)) {
        if ($(Split-Path $fileOrName -Leaf) -ne "Dockerfile") {
            Write-Warning "Expected path to Dockerfile but got path to $(Split-Path $fileOrName -Leaf)"

            exit 1
        }

        $file = $fileOrName
    }
    else {
        $file = Join-Path $PSScriptRoot $fileOrName "Dockerfile"
    }

    if (-not (Test-Path $file)) {
        Write-Warning "File or directory not found ($file)"

        exit 1
    }

    if ((Get-Item $file).PSIsContainer) {
        Write-Warning "Expected file but found directory ($file)"

        exit 1
    }

    $name = [System.IO.Path]::GetRelativePath($PSScriptRoot, (Split-Path $file -Parent))

    $parent = Split-Path $PSScriptRoot -Parent
    $name = "$(Split-Path $parent -Leaf)/$name"

    return $file, $name
}

function Get-DockerImageTag {
    param (
        [string] $path,
        [string] $version
    )

    $prefix = Get-DockerRepositoryPrefix

    $name = Split-Path $path -Leaf
    $path = Split-Path $path -Parent

    while ($path -ine $PSScriptRoot) {
        $name = "$(Split-Path $path -Leaf)/$name"
        $path = Split-Path $path -Parent
    }

    return "$prefix/$name`:$version"
}

Export-ModuleMember Get-DockerImageTag
Export-ModuleMember Get-DockerfilePath