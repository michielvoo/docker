. $PSScriptRoot/Environment.ps1

Function Use-CidLogGroup
{
    Param(
        [Parameter(Mandatory)]
        [string] $Message,

        [Parameter(Mandatory)]
        [ScriptBlock] $ScriptBlock
    )

    # GitHub Actions workflow commands
    # TeamCity service messages
    # Azure DevOps formatting commands

    Process
    {
        Try
        {
            Write-Host (((IsGH) ? "::group::{{{0}}}" : (IsTC) ? "##teamcity[blockOpened name='{0}' description='']" : (IsTF) ? "##[group]{0}" : ">>> {0}") -f $Message)

            & $ScriptBlock

            Write-Host ((IsGH) ? "::endgroup::" : ((IsTC) ? "##teamcity[blockClosed name='{0}']" : (IsTF) ? "##[endgroup]" : "<<< {0}") -f $Message)
        }
        Catch
        {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}
