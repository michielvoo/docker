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
                New-Object -TypeName "Amazon.CloudFormation.Model.Parameter" -Property @{
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
                New-Object -TypeName "Amazon.CloudFormation.Model.Tag" -Property @{
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

Function Get-CFNChangeSetName
{
    param(
        [Parameter(Mandatory)]
        [string] $Name
    )

    Return Get-CFNStackName -Name $Name
}

Function Get-CFNStackName
{
    param(
        [Parameter(Mandatory)]
        [string] $Name
    )

    $Result = $Name -replace "[._]","-"
    $Result = $Result -replace "[^0-9A-Za-z-]",""
    $Result = $Result -replace "-+","-"
    $Result = $Result.Substring(0, [System.Math]::Min($Result.Length, 128))

    Return $Result
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
        The name that is associated with the stack. By default $CidContext.Name 
        is used.

    .PARAMETER ChangeSetName
        The name of the change set used to deploy the stack. By default 
        $CidContext.Name is used.

    .PARAMETER Region
        The system name of an AWS region or an AWSRegion instance. By default 
        $StoredAWSRegion is used.

    .PARAMETER Timeout
        The amount of time in seconds to wait for deployment to complete.

    .PARAMETER Remaining
        All remaining command line parameters will be associated with this 
        parameter and will be passed on to the New-CFNStack or Update-CFNStack 
        cmdlet.

    .EXAMPLE
        Deploy-CFNStack -StackName "..." -TemplateBody "..." -Parameter @()
    #>

    Param(
        [Parameter()]
        [string] $StackName = $CidContext.Name,

        [Parameter()]
        [string] $ChangeSetName = "$($CidContext.Name)-$($CidContext.Run)",

        [Parameter()]
        [string] $Region = $StoredAWSRegion,

        [Parameter()]
        [int] $Timeout = 900,

        [Parameter(ValueFromRemainingArguments)]
        [object[]] $Remaining
    )

    Process
    {
        Try
        {
            $StackName = Get-CFNStackName -Name $StackName
            $ChangeSetName = Get-CFNChangeSetName -Name $ChangeSetName

            $ChangeSetType = "CREATE"

            If (Test-CFNStack -StackName $StackName -Region $Region)
            {
                $Stack = Get-CFNStack -StackName $StackName -Region $Region
                $Status = $Stack.StackStatus

                If ($Status -eq "REVIEW_IN_PROGRESS")
                {
                    $ChangeSetType = "CREATE"
                }
                ElseIf ($Status -eq "CREATE_COMPLETE" -or $Status -eq "UPDATE_COMPLETE")
                {
                    $ChangeSetType = "UPDATE"
                }
                Else
                {
                    Throw "Stack with status $Status cannot be deployed"
                }

                Write-Verbose "Updating existing stack '$StackName' in region $Region"
            }
            Else
            {
                Write-Verbose "Creating new stack '$StackName' in region $Region"
            }

            $Parameters = @{
                ChangeSetName = $ChangeSetName
                ChangeSetType = $ChangeSetType
                Region = $Region
                StackName = $StackName
            }
            For ($i = 0; $i -lt $Remaining.Count; $i += 2)
            {
                $Name = $Remaining[$i]
                $Value = $Remaining[$i + 1]

                $Parameters.Add($Name, $Value)
            }

            Write-Verbose "Creating new change set '$ChangeSetName' for stack '$StackName' in region '$Region'"

            New-CFNChangeSet @Parameters | Out-Null

            $ChangeSet = Get-CFNChangeSet -StackName $StackName -ChangeSetName $ChangeSetName -Region $Region
            While ($ChangeSet.Status -eq "CREATE_PENDING" -or $ChangeSet.Status -eq "CREATE_IN_PROGRESS")
            {
                $ChangeSet = Get-CFNChangeSet -StackName $StackName -ChangeSetName $ChangeSetName -Region $Region
            }

            If ($ChangeSet.Status -eq "FAILED" -and $ChangeSet.Changes.Count -eq 0)
            {
                Remove-CFNChangeSet -ChangeSetName $ChangeSetName -Force -Region $Region -StackName $StackName
                Write-Verbose "Deployed stack '$StackName' in region $Region with no changes"

                Return
            }
            ElseIf ($ChangeSet.Status -ne "CREATE_COMPLETE")
            {
                Throw "Change set with status $($ChangeSet.Status) cannot be started"
            }

            If ($ChangeSet.ExecutionStatus -ne "AVAILABLE")
            {
                Throw "Change set with execution status $($ChangeSet.ExecutionStatus) cannot be started"
            }

            Write-Verbose "Starting change set '$ChangeSetName' with $($ChangeSet.Changes.Count) changes for stack '$StackName' in region $Region"

            Start-CFNChangeSet -StackName $StackName -ChangeSetName $ChangeSetName -Region $Region
            Wait-CFNStack -StackName $StackName -Timeout $Timeout -Region $Region | Out-Null

            Write-Verbose "Deployed stack '$StackName' in region $Region"
        }
        Catch
        {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}
