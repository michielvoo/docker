Function Get-AWSParameters
{
    <#
    .SYNOPSIS
        Convert JSON content to an array of AWS parameters.

    .DESCRIPTION
        The JSON file should contain an array of objects, each object should 
        have a ParameterKey and ParameterValue property. This cmdlet returns an 
        array of object of type Amazon.CloudFormation.Model.Parameter.

    .PARAMETER Path
        Specifies the path to an item where Get-AWSParameters gets the JSON 
        content. Wildcard characters are permitted. The paths must be paths to 
        items, not to containers. For example, you must specify a path to one 
        or more files, not a path to a directory.
    #>

    Param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string] $Path
    )

    Process
    {
        Return Get-Content -Path $Path -Raw |
            ConvertFrom-Json |
            ForEach-Object -Process {
                New-Object Amazon.CloudFormation.Model.Parameter -Property @{
                    ParameterKey = $_.ParameterKey
                    ParameterValue = $_.ParameterValue
                }
            }
    }
}

Function Deploy-CFNStack
{
    <#
    .SYNOPSIS
        Deploy a new or existing CloudFormation stack.

    .DESCRIPTION
        If the CloudFormation stack specified in StackName does not exist it is 
        created, otherwise it is updated. Parameters passed to this cmdlet will 
        be passed on to the New-CFNStack or Update-CFNStack cmdlets.

    .PARAMETER StackName
        The name that is associated with the stack.

    .EXAMPLE
        Deploy-CFNStack -StackName "myStack" `
            -TemplateBody "{TEMPLATE CONTENT HERE}" `
            -Parameter @(
                @{ ParameterKey="PK1"; ParameterValue="PV1" },
                @{ ParameterKey="PK2"; ParameterValue="PV2" }
            )
    #>

    Param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string] $StackName
    )

    Process
    {
        $Verb = "Update"

        Try
        {
            $Stack = Get-CFNStack -StackName $StackName

            Write-Host "Updating existing stack"
        }
        Catch [Amazon.CloudFormation.AmazonCloudFormationException]
        {
            If ($_.Exception.Message -eq "Stack with id $StackName does not exist")
            {
                $Verb = "New"

                Write-Host "Creating new stack"
            }
            Else
            {
                Throw
            }
        }

        $Expression = $Verb + "-CFNStack -StackName " + $StackName + " " + $MyInvocation.UnboundArguments -join " "
        Write-Host $Expression
    }
}
