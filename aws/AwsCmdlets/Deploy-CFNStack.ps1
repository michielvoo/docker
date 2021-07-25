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
        Try
        {
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

            $Parameters = @{}
            For ($i = 0; $i -lt $Remaining.Count; $i += 2)
            {
                $Name = $Remaining[$i]
                $Value = $Remaining[$i + 1]

                $Parameters.Add($Name, $Value)
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
            }
            ElseIf ($ChangeSet.ExecutionStatus -ne "AVAILABLE")
            {
                Write-Host "Unable to execute change set $ChangeSet."
            }
            Else
            {
                Write-Host "Executing change set $ChangeSetName..."

                Start-CFNChangeSet -StackName $StackName -ChangeSetName $ChangeSetName
                $Stack = Wait-CFNStack -StackName $StackName -Timeout $Timeout

                Write-Host "Deployed stack $StackName."
            }

            Return $Stack
        }
        Catch
        {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}
