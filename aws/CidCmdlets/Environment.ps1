Function IsGH
{
    Test-Path -Path "Env:GITHUB_ACTION"
}

Function IsGit
{
    git rev-parse *> Out-Null
    Return -not $LastExitCode
}

Function IsTC
{
    Test-Path -Path "Env:TEAMCITY_VERSION"
}

Function IsTF
{
    Test-Path -Path "Env:TF_BUILD"
}
