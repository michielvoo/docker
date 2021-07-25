Function ConvertTo-CFNParameters
{
    <#
    .SYNOPSIS
        Convert JSON content to an array of AWS CloudFormation parameters.

    .DESCRIPTION
        The JSON content should contain an array of objects, each object should 
        have a ParameterKey and ParameterValue property. This cmdlet returns an 
        array of object of type Amazon.CloudFormation.Model.Parameter.

    .PARAMETER Json
        Specifies the JSON content.

    .EXAMPLE
        ConvertTo-CFNParameters -Json (Get-Content -Path "aws/infrastructure.prd.json" -Raw)
    #>

    Param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string] $Json
    )

    Process
    {
        Try
        {
            Return ConvertFrom-Json $Json | ForEach-Object {
                New-Object Amazon.CloudFormation.Model.Parameter -Property @{
                    ParameterKey = $_.ParameterKey
                    ParameterValue = $_.ParameterValue
                }
            }
        }
        Catch
        {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}
