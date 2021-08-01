$Format = @{
    gh = @{ 
        Open = { "::group::{{{0}}}" -f $Args[0] }
        Close = { "::endgroup::" }
    }
    tc = @{ # TeamCity service messages
        Open = { "##teamcity[blockOpened name='{0}' description='']" -f $Args[0] }
        Close = { "##teamcity[blockClosed name='{0}']" -f $Args[0] }
    }
    tf = @{ # Azure DevOps formatting commands
        Open = { "##[group]{0}" -f $Args[0] }
        Close = { "##[endgroup]" }
    }
    manual = @{
        Open = { ">>> {0} >>>" -f $Args[0] }
        Close = { "<<< {0} <<<" -f $Args[0] }
    }
}

Function Use-CidLogGroup
{
    Param(
        [Parameter(Mandatory)]
        [string] $Message,

        [Parameter(Mandatory)]
        [ScriptBlock] $ScriptBlock
    )

    Process
    {
        Try
        {
            Write-Host (Invoke-Command -ScriptBlock $Format[$CidContext.Runner].Open -ArgumentList $Message)

            & $ScriptBlock

            Write-Host (Invoke-Command -ScriptBlock $Format[$CidContext.Runner].Close -ArgumentList $Message)
        }
        Catch
        {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}
