param (
    [Parameter(Mandatory, Position = 0)]
    [string] $Task,

    [Parameter(ValueFromRemainingArguments)]
    [string[]] $Arguments
)

switch ($Task) {
    "Build" {
        if ($Arguments.Length -lt 2) {
            Write-Warning "Build task requires two arguments"

            return
        }

        $workspaceFolder = $Arguments[0]
        $fileOrName = $Arguments[1]

        if (-not (Test-Path $workspaceFolder)) {
            Write-Warning "File or directory not found ($workspaceFolder)"

            return
        }

        if (-not (Get-Item $workspaceFolder).PSIsContainer) {
            Write-Warning "Expected directory but found file ($workspaceFolder)"

            return
        }

        if ([System.IO.Path]::IsPathRooted($fileOrName)) {
            if ($(Split-Path $fileOrName -Leaf) -ne "Dockerfile") {
                Write-Warning "Expected path to Dockerfile but got path to $(Split-Path $fileOrName -Leaf)"

                return
            }

            $file = $fileOrName
            $name = [System.IO.Path]::GetRelativePath($workspaceFolder, (Split-Path $fileOrName -Parent))
        }
        else {
            $file = Join-Path $workspaceFolder $fileOrName "Dockerfile"
            $name = $fileOrName
        }

        if (-not (Test-Path $file)) {
            Write-Warning "File or directory not found ($file)"

            return
        }

        if ((Get-Item $file).PSIsContainer) {
            Write-Warning "Expected file but found directory ($file)"

            return
        }

        Push-Location $(Split-Path $file -Parent)

        docker build . --tag "$name"

        Pop-Location
    }
}
