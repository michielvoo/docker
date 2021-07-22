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
        created, otherwise it is updated. Parameters passed to this cmdlet via 
        will be passed on to the New-CFNStack or Update-CFNStack cmdlets.

    .PARAMETER StackName
        The name that is associated with the stack.

    .PARAMETER Timeout
        The amount of time in seconds to wait for deployment to complete.

    .PARAMETER Remaining
        All remaining command line parameters will be associated with this 
        parameter and will be passed on to the New-CFNStack or Update-CFNStack 
        cmdlet.

    .EXAMPLE
        Deploy-CFNStack `
            -StackName "..." `
            -TemplateBody "..." `
            -Parameter @()
    #>

    Param(
        [Parameter(Mandatory)]
        [string] $StackName,

        [Parameter(Mandatory)]
        [string] $ChangeSetName,

        [int] $Timeout = 900,

        [Parameter(ValueFromRemainingArguments)]
        [object[]] $Remaining
    )

    Process
    {
        $Parameters = @{}
        For ($i = 0; $i -lt $Remaining.Count; $i += 2)
        {
            $Name = $Remaining[$i]
            $Value = $Remaining[$i + 1]

            $Parameters.Add($Name, $Value)
        } 

        $ChangeSetType = "UPDATE"

        Try
        {
            $Stack = Get-CFNStack -StackName $StackName

            If ($Stack.StackStatus -eq "REVIEW_IN_PROGRESS")
            {
                $ChangeSetType = "CREATE"
            }
        }
        Catch
        {
            $Message = $_.Exception.Message

            If ($Message -eq "Stack with id $StackName does not exist")
            {
                $ChangeSetType = "CREATE"
            }
            Else
            {
                Throw
            }
        }

        $ChangeSet = New-CFNChangeSet -StackName $StackName -ChangeSetName $ChangeSetName -ChangeSetType $ChangeSetType @Parameters

        Do
        {
            $ChangeSet = Get-CFNChangeSet -StackName $StackName -ChangeSetName $ChangeSetName
            Start-Sleep -Seconds 3
        }
        While (($ChangeSet.Status -eq "CREATE_PENDING") -or ($ChangeSet.Status -eq "CREATE_IN_PROGRESS"))

        If ($ChangeSet.Status -eq "FAILED")
        {
            Write-Host "Skipped deployment of stack $StackName." $ChangeSet.StatusReason

            Return
        }

        If ($ChangeSet.ExecutionStatus -eq "AVAILABLE")
        {
            Write-Host "Executing change set $ChangeSetName..."

            Start-CFNChangeSet -StackName $StackName -ChangeSetName $ChangeSetName
            $Stack = Wait-CFNStack -StackName $StackName -Timeout $Timeout

            Write-Host "Deployed stack $StackName."
        }
        Else
        {
            Write-Host "Unable to execute change set $ChangeSet."
        }
    }
}
