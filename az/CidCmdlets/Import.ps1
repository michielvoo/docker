$FormatOpenGroup = ">>> {0}"
$FormatCloseGroup = "<<< {0}"

If ($Env:TF_BUILD)
{
    # Azure DevOps formatting commands

    $FormatOpenGroup = "##[group]{0}"
    $FormatCloseGroup = "##[endgroup]"
}
ElseIf ($Env:GITHUB_ACTION)
{
    # GitHub Actions workflow commands

    $FormatOpenGroup = "::group::{{{0}}}"
    $FormatCloseGroup = "::endgroup::"
}
ElseIf ($Env:TEAMCITY_VERSION)
{
    # TeamCity service messages

    $FormatOpenGroup = "##teamcity[blockOpened name='{0}' description='']"
    $FormatCloseGroup = "##teamcity[blockClosed name='{0}']"

}
