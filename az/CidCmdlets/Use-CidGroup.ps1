Function Use-CidGroup
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
            Write-Host ($FormatOpenGroup -f $Message)

            & $ScriptBlock

            Write-Host ($FormatCloseGroup -f $Message)
        }
        Catch
        {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}
