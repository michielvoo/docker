# Utilities for use in Pester tests, Visual Studio Code tasks, and GitHub workflows

function Get-DockerRepositoryPrefix {
    $path = $PSScriptRoot
    if ($Env:GITHUB_REPOSITORY) {
        $path = $Env:GITHUB_REPOSITORY
    }

    $path = Split-Path $path -Parent

    return Split-Path $path -Leaf
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