Function ConvertTo-CFNTags
{
    <#
    .SYNOPSIS
        Convert a hashtable to an array of AWS CloudFormation tags.

    .PARAMETER Tags
        The hashtable to convert.

    .EXAMPLE
        ConvertTo-CFNTags -Tags @{ "environment" = "prd" }
    #>

    param
    (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [hashtable] $Tags
    )

    Process
    {
        Try
        {
            Return $Tags.GetEnumerator() | ForEach-Object {
                New-Object Amazon.CloudFormation.Model.Tag -Property @{
                    Key = $_.Name
                    Value = $_.Value.ToString()
                }
            }
        }
        Catch
        {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}
