$Format = @{
    az = @{ # Azure DevOps logging commands
        Open = { "##[group]{0}" -f $Args[0] }
        Close = { "##[endgroup]" }
        Header = { "##[section]{0}" -f $Args[0] }
    }
    bit = @{ # Bitbucket ?
        Open = { "{0}" -f $Args[0] }
        Close = { "" }
        Header = { "{0}" -f $Args[0] }
    }
    gh = @{ # GitHub Actions workflow commands
        Open = { "::group::{0}" -f $Args[0] }
        Close = { "::endgroup::" }
        Header = { "### {0} ###" -f $Args[0] }
    }
    gl = @{ # GitLab ?
        Open = { "{0}" -f $Args[0] }
        Close = { "" }
        Header = { "{0}" -f $Args[0] }
    }
    tc = @{ # TeamCity service messages
        Open = { "##teamcity[blockOpened name='{0}' description='']" -f $Args[0] }
        Close = { "##teamcity[blockClosed name='{0}']" -f $Args[0] }
        Header = { "### {0} ###" -f $Args[0] }
    }
    local = @{
        Open = { ">>> {0} >>>" -f $Args[0] }
        Close = { "<<< {0} <<<" -f $Args[0] }
        Header = { "### {0} ###" -f $Args[0] }
    }
}

Function Use-CidLogGroup
{
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string] $Message,

        [Parameter(Mandatory, ValueFromPipeline)]
        [ScriptBlock] $ScriptBlock
    )

    Process
    {
        Try
        {
            $Tags = $Format[$CidContext.Runner] ?? $Format["local"]

            Write-Host (Invoke-Command -ScriptBlock $Tags.Open -ArgumentList $Message)

            & $ScriptBlock

            Write-Host (Invoke-Command -ScriptBlock $Tags.Close -ArgumentList $Message)
        }
        Catch
        {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}

Function Write-CidLogHeader
{
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string] $Message
    )

    Process
    {
        $Tags = $Format[$CidContext.Runner] ?? $Format["local"]

        Write-Host (Invoke-Command -ScriptBlock $Tags.Header -ArgumentList $Message)
    }
}
