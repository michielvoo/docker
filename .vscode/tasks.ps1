function Invoke-Task {
    param (
        [Parameter(Mandatory, Position = 0)]
        [string] $Task,

        [Parameter(ValueFromRemainingArguments)]
        [string[]] $Arguments
    )

    switch ($Task) {
        "Build" {
            $file, $name = Get-DockerfilePath $Arguments[0] $Arguments[1]

            Push-Location $(Split-Path $file -Parent)

            docker build "." `
                --tag "$name`:dev" `
                --label "org.opencontainers.image.source=$file"

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

function Get-DockerfilePath {
    param (
        [string]$workspaceFolder,
        [string]$fileOrName
    )

    if (-not (Test-Path $workspaceFolder)) {
        Write-Warning "File or directory not found ($workspaceFolder)"

        exit 1
    }

    if (-not (Get-Item $workspaceFolder).PSIsContainer) {
        Write-Warning "Expected directory but found file ($workspaceFolder)"

        exit 1
    }

    if ([System.IO.Path]::IsPathRooted($fileOrName)) {
        if ($(Split-Path $fileOrName -Leaf) -ne "Dockerfile") {
            Write-Warning "Expected path to Dockerfile but got path to $(Split-Path $fileOrName -Leaf)"

            exit 1
        }

        $file = $fileOrName
    }
    else {
        $file = Join-Path $workspaceFolder $fileOrName "Dockerfile"
    }

    if (-not (Test-Path $file)) {
        Write-Warning "File or directory not found ($file)"

        exit 1
    }

    if ((Get-Item $file).PSIsContainer) {
        Write-Warning "Expected file but found directory ($file)"

        exit 1
    }

    $name = [System.IO.Path]::GetRelativePath($workspaceFolder, (Split-Path $file -Parent))

    $parent = Split-Path $workspaceFolder -Parent
    $name = "$(Split-Path $parent -Leaf)/$name"

    return $file, $name
}

Invoke-Task $args[0] ($args | Select-Object  -Skip 1)