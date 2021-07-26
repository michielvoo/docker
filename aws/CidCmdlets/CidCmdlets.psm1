$IsGH = Test-Path -Path "Env:GITHUB_ACTION"
$IsTC = Test-Path -Path "Env:TEAMCITY_VERSION"
$IsTF = Test-Path -Path "Env:TF_BUILD"

Function Get-CidConstants
{
    $Result = [Ordered] @{}

    $Environment = @{
        ArtifactsPath = $Env:CID_ARTIFACTS_PATH
        Commit = $Env:CID_COMMIT_ID
        Deployment = $Env:CID_DEPLOYMENT
        Environment = $Env:CID_ENVIRONMENT
        Name = $Env:CID_NAME
        Run = $Env:CID_RUN_ID
    }

    $Runner = @{
        ArtifactsPath = $IsTF ? $Env:BUILD_BINARIESDIRECTORY : $Null
        Run = $IsTF ? $Env:BUILD_BUILDID : $null
    }

    git rev-parse *> Out-Null
    $IsGit = -not $LastExitCode
    $Commit = $IsGit ? (git rev-parse HEAD) : "unknown"
    $GitRepositoryName = $IsGit ? (Split-Path -Path ((git config --get remote.origin.url) -replace "\.git$","") -Leaf) : "unknown"

    $Name = (($Result.Name ?? $GitRepositoryName) -replace "[^\d\w.]", "-") -replace "-+", "-"
    $Timestamp = Get-Date -AsUTC -Format FileDateTimeUniversal

    $Defaults = @{
        ArtifactsPath = Join-Path -Path (Get-Location) -ChildPath "artifacts"
        Commit = $Commit
        Deployment = "$Name-$Commit-$Timestamp"
        Environment = "dev"
        Name = $Name
        Run = $Timestamp
        Trigger = ($IsGH || $IsTC || $IsTF) ? "auto" : "manual"
    }

    $Defaults.Keys | Sort-Object | ForEach-Object {
        $Result[$_] = $Environment[$_] ?? $Runner[$_] ?? $Defaults[$_]
    }

    Return $Result.AsReadOnly()
}

Set-Variable -Name "Cid" -Value (Get-CidConstants)

Export-ModuleMember -Variable "Cid"

. "$PSScriptRoot/Logging.ps1"
