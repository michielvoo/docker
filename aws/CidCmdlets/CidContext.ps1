Function Get-CidContext
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

    $Runner = Get-CidContextFromRunner
    $Scm = Get-CidContextFromScm

    $Environment = @{
        ArtifactsPath = $Env:CID_ARTIFACTS_PATH
        Commit = $Env:CID_COMMIT
        Deployment = $Env:CID_DEPLOYMENT
        Environment = $Env:CID_ENVIRONMENT
        Name = $Env:CID_NAME
        Run = $Env:CID_RUN
        Runner = $Env:CID_RUNNER
        Scm = $Env:CID_SCM
    }

    $Result = [Ordered] @{}

    $Defaults.Keys | Sort-Object | ForEach-Object {
        $Result[$_] = $Environment[$_] ?? $Runner[$_] ?? $Scm[$_] ?? $Defaults[$_]
    }

    $Result.Deployment = $Result.Deployment ?? "$($Result.Name)-$($Result.Scm)$($Result.Commit)-$($Result.Runner)$($Result.Run)"

    Return $Result.AsReadOnly()
}

Function Get-CidContextFromRunner
 {
    If (Test-Path -Path "Env:BUILD_BUILDID")
    {
        Return @{
            ArtifactsPath = $Env:BUILD_BINARIESDIRECTORY
            Run = $Env:BUILD_BUILDID
            Runner = "az"
        }
    }
    ElseIf (Test-Path -Path "Env:BITBUCKET_BUILD_NUMBER")
    {
        Return @{
            Run = $Env:BITBUCKET_BUILD_NUMBER
            Runner = "bit"
        }
    }
    ElseIf (Test-Path -Path "Env:GITHUB_RUN_ID")
    {
        Return @{
            Run = $Env:GITHUB_RUN_ID
            Runner = "gh"
        }
    }
    ElseIf (Test-Path -Path "Env:CI_JOB_ID")
    {
        Return @{
            Run = $Env:CI_JOB_ID
            Runner = "gl"
        }
    }
    ElseIf (Test-Path -Path "Env:BUILD_NUMBER")
    {
        Return @{
            Run = $Env:BUILD_NUMBER
            Runner = "tc"
        }
    }
    Else
    {
        Return @{
            ArtifactsPath = Join-Path -Path (Get-Location) -ChildPath "artifacts"
            Run = Get-Date -AsUTC -Format FileDateTimeUniversal
            Runner = "local"
        }
    }
 }

Function Get-CidContextFromScm
{
    git rev-parse *> $Null

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
            Commit = "unknown"
            Name = Split-Path -Path (Get-Location) -Leaf
        }
    }
}
