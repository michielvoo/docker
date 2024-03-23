Import-Module "$PSScriptRoot/../Utilities.psm1"

function Invoke-Task {
    param (
        [Parameter(Mandatory, Position = 0)]
        [string] $Task,

        [Parameter(ValueFromRemainingArguments)]
        [string[]] $Arguments
    )

    switch ($Task) {
        "Build" {
            $metadata = Get-DockerMetadata $Arguments[0]

            Push-Location $data.Directory

            $build = "docker buildx build"
            foreach ($label in $metadata.Labels.GetEnumerator()) {
                $build = "$build --label ""$($label.Name)=$($label.Value)"""
            }
            $build = "$build --output ""type=image,name=$($metadata.Name):dev,push=false"""
            $build = "$build --file ""$($metadata.Dockerfile)"""
            $build = "$build ""$($metadata.Directory)"""

            Invoke-Expression $build

            Pop-Location
        }

        "Test" {
            if ($Arguments.Length -eq 0) {
                Write-Warning "Test task requires one argument"
    
                return
            }
    
            $path = $Arguments[0]
    
            if (-not (Test-Path $path)) {
                Write-Warning "File or directory not found ($path)"
    
                return
            }
    
            $configuration = New-PesterConfiguration
            $configuration.Run.Path = $path
    
            if ((Get-Item $path).PSIsContainer) {
                Invoke-Pester -Configuration $configuration
    
                return
            }
    
            $configuration.Output.Verbosity = "Detailed"
    
            if ($path.ToLowerInvariant().EndsWith(".tests.ps1")) {
                Invoke-Pester -Configuration $configuration
    
                return
            }
    
            if ((Split-Path $path -Leaf) -ne "Dockerfile") {
                Write-Warning "File is not a Dockerfile ($path)"
    
                return
            }

            $path = Join-Path (Split-Path $path -Parent) "Dockerfile.Tests.ps1"
    
            if (Test-Path $path) {
                $configuration.Run.Path = $path
                Invoke-Pester -Configuration $configuration
    
                return
            }
    
            Write-Warning "File not found ($path)"
        }
    }
}

Invoke-Task $args[0] ($args | Select-Object  -Skip 1)