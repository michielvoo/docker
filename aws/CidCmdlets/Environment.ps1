Function Get-CidEnvironment
{
    $Defaults = @{
        ArtifactsPath = $Null
        Commit = $Null
        Deployment = $Null
        Environment = "dev"
        Name = $Null
        Run = $Null
        Runner = $Null
        Scm = $Null
    }

    $Runner = Get-CidRunner
    $Scm = Get-CidScm

    $Environment = @{
        ArtifactsPath = $Env:CID_ARTIFACTS_PATH
        Commit = $Env:CID_COMMIT_ID
        Deployment = $Env:CID_DEPLOYMENT
        Environment = $Env:CID_ENVIRONMENT
        Name = $Env:CID_NAME
        Run = $Env:CID_RUN_ID
    }

    $Result = [Ordered] @{}

    $Defaults.Keys | Sort-Object | ForEach-Object {
        $Result[$_] = $Environment[$_] ?? $Runner[$_] ?? $Scm[$_] ?? $Defaults[$_]
    }

    $Result.Deployment = $Result.Deployment ?? "$($Result.Name)-$($Result.Scm)$($Result.Commit)-$($Result.Runner)$($Result.Run)"

    Return $Result.AsReadOnly()
}

Function Get-CidRunner
{
    If (Test-Path -Path "Env:GITHUB_ACTION")
    {
        Return @{
            Runner = "gh"
        }
    }
    ElseIf (Test-Path -Path "Env:TEAMCITY_VERSION")
    {
        Return @{
            Runner = "tc"
        }
    }
    ElseIf (Test-Path -Path "Env:TF_BUILD")
    {
        Return @{
            ArtifactsPath = $Env:BUILD_BINARIESDIRECTORY
            Run = $Env:BUILD_BUILDID
            Runner = "tf"
        }
    }
    Else
    {
        Return @{
            ArtifactsPath = Join-Path -Path (Get-Location) -ChildPath "artifacts"
            Run = Get-Date -AsUTC -Format FileDateTimeUniversal
            Runner = "manual"
        }
    }
}

Function Get-CidScm
{
    git rev-parse *> Out-Null

    If ($LastExitCode -eq 0)
    {
        $OriginUrl = git config --get remote.origin.url

        Return @{
            Commit = git rev-parse HEAD
            Name = Split-Path -Path ($OriginUrl -replace "\.git$","") -Leaf
            Scm = "git"
        }
    }
    Else
    {
        Return @{
            Commit = "none"
            Name = Split-Path -Path (Get-Location) -Leaf
            Scm = "none"
        }
    }
}
