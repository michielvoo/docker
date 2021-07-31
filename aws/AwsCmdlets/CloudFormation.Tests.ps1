BeforeAll {
    . $PSScriptRoot/CloudFormation.ps1
}

Describe "ConvertTo-CFNParameters" {
    BeforeAll {
        Mock New-Object {
            $Object = @{}
            $Property.GetEnumerator() | ForEach-Object {
                $Object[$_.Name] = $_.Value
            }
            Return $Object
        } -ParameterFilter { $TypeName -eq "Amazon.CloudFormation.Model.Parameter" }
    }

    It "Converts a JSON array to an array of CloudFormation parameters" {
        $Json = ConvertTo-Json -InputObject @(
            @{ ParameterKey = "A"; ParameterValue = "12" }
            @{ ParameterKey = "B"; ParameterValue = "42" }
        )

        $Parameters = ConvertTo-CFNParameters -Json $Json

        $Parameters[0].ParameterKey | Should -Be "A"
        $Parameters[0].ParameterValue | Should -Be "12"
        $Parameters[1].ParameterKey | Should -Be "B"
        $Parameters[1].ParameterValue | Should -Be "42"
    }
}

Describe "ConvertTo-CFNTags" {
    BeforeAll {
        Mock New-Object {
            $Object = @{}
            $Property.GetEnumerator() | ForEach-Object {
                $Object[$_.Name] = $_.Value
            }
            Return $Object
        } -ParameterFilter { $TypeName -eq "Amazon.CloudFormation.Model.Tag" }
    }

    It "Converts a hashtable to an array of CloudFormation tags" {
        $Hashtable = @{
            "A" = "12"
            "B" = 42
        }

        $Tags = ConvertTo-CFNTags -Tags $Hashtable

        $Tags[0].Key = "A"
        $Tags[0].Value = "12"
        $Tags[1].Key = "B"
        $Tags[1].Value = "42"
    }
}

Describe "Deploy-CFNStack" {
    BeforeAll {
        $ChangeSet = @{
            ExecutionStatus = "AVAILABLE"
            Status = "CREATE_COMPLETE"
        }

        Function Get-CFNChangeSet { param($ChangeSetName, $StackName) $ChangeSet }
        Function Get-CFNStack { param($StackName) }
        Function New-CFNChangeSet { param($ChangeSetName, $ChangeSetType, $StackName, $Parameter) }
        Function Start-CFNChangeSet { param($ChangeSetName, $StackName) }
        Function Test-CFNStack {}
        Function Wait-CFNStack { param($StackName, $Timeout) }

        Mock New-CFNChangeSet {}
        Mock Test-CFNStack { $False }
    }

    Context "When stack exist" {
        BeforeAll {
            $Stack = @{}

            Mock Get-CFNStack { $Stack } -ParameterFilter { $StackName -eq "Stack" }
            Mock Test-CFNStack { $True }
        }

        It "Creates change set of type CREATE if stack status is REVIEW_IN_PROGRESS" {
            $Stack.StackStatus = "REVIEW_IN_PROGRESS"

            Deploy-CFNStack -StackName "Stack" -ChangeSetName "ChangeSet"

            Should -Invoke -CommandName New-CFNChangeSet -ParameterFilter { $ChangeSetType -eq "CREATE" }
        }

        It "Creates change set of type UPDATE if stack status is CREATE_COMPLETE" {
            $Stack.StackStatus = "CREATE_COMPLETE"

            Deploy-CFNStack -StackName "Stack" -ChangeSetName "ChangeSet"

            Should -Invoke -CommandName New-CFNChangeSet -ParameterFilter { $ChangeSetType -eq "UPDATE" }
        }

        It "Creates change set of type UPDATE if stack status is UPDATE_COMPLETE" {
            $Stack.StackStatus = "UPDATE_COMPLETE"

            Deploy-CFNStack -StackName "Stack" -ChangeSetName "ChangeSet"

            Should -Invoke -CommandName New-CFNChangeSet -ParameterFilter { $ChangeSetType -eq "UPDATE" }
        }

        It "Terminates if stack status is not supported" {
            $Stack.StackStatus = "SOME_UNSUPPORTED_STATUS"

            { Deploy-CFNStack -StackName "Stack" -ChangeSetName "ChangeSet" } | Should -Throw
        }
    }

    It "Creates change set of type CREATE" {
        Deploy-CFNStack -StackName "Stack" -ChangeSetName "ChangeSet"

        Should -Invoke -CommandName New-CFNChangeSet -ParameterFilter { $ChangeSetType -eq "CREATE" }
    }

    It "Creates change set with stack name" {
        Deploy-CFNStack -StackName "Stack" -ChangeSetName "ChangeSet"

        Should -Invoke -CommandName New-CFNChangeSet -ParameterFilter { $StackName -eq "Stack" }
    }

    It "Creates new change set with change set name" {
        Deploy-CFNStack -StackName "Stack" -ChangeSetName "ChangeSet"

        Should -Invoke -CommandName New-CFNChangeSet -ParameterFilter { $ChangeSetName -eq "ChangeSet" }
    }

    It "Creates new change set with remaining parameters" {
        Deploy-CFNStack -StackName "Stack" -ChangeSetName "ChangeSet" -Parameter "Value"

        Should -Invoke -CommandName New-CFNChangeSet -ParameterFilter { $Parameter -eq "Value" }
    }

    It "Terminates if change set status becomes an unsupported status" {
        $ChangeSet = @{
            Status = "CREATE_PENDING"
        }

        Mock Get-CFNChangeSet {
            If ($ChangeSet.Status -eq "CREATE_PENDING")
            {
                $ChangeSet.Status = "CREATE_IN_PROGRESS"
            }
            Else
            {
                $ChangeSet.Status = "SOME_UNSUPPORTED_STATUS"
            }

            Return $ChangeSet
        } -ParameterFilter { $ChangeSetName -eq "ChangeSet" -and $StackName -eq "Stack" }

        { Deploy-CFNStack -StackName "Stack" -ChangeSetName "ChangeSet" } | Should -Throw
    }

    It "Terminates if change set execution status is not supported" {
        $ChangeSet = @{
            ExecutionStatus = "SOME_UNSUPPORTED_STATUS"
            Status = "CREATE_COMPLETE"
        }

        Mock Get-CFNChangeSet { $ChangeSet } -ParameterFilter { $ChangeSetName -eq "ChangeSet" -and $StackName -eq "Stack" }

        { Deploy-CFNStack -StackName "Stack" -ChangeSetName "ChangeSet" } | Should -Throw
    }

    It "Starts the change set" {
        Mock Start-CFNChangeSet {}

        Deploy-CFNStack -StackName "Stack" -ChangeSetName "ChangeSet"

        Should -Invoke -CommandName Start-CFNChangeSet -ParameterFilter { $StackName -eq "Stack" -and $ChangeSetName -eq "ChangeSet" }
    }

    It "Waits for and returns the stack" {
        Mock Wait-CFNStack { "stack" }

        Deploy-CFNStack -StackName "Stack" -ChangeSetName "ChangeSet" -Timeout 30 | Should -Be "stack"

        Should -Invoke -CommandName Wait-CFNStack -ParameterFilter { $StackName -eq "Stack" -and $Timeout -eq 30 }
    }
}
