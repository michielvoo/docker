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
