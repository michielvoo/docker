BeforeAll { 
    . $PSScriptRoot/Logging.ps1
}

Describe "Use-CidLogGroup" {
    It "Returns the script block's return value" {
        $Result = Use-CidLogGroup -Message "Test" {
            42
        } 6>$Null
        $Result | Should -Be 42
    }

    Context "Locally" {
        It "Writes open and close tags" {
            Use-CidLogGroup -Message "Test" {} 6>&1 | Should -Be @(">>> Test", "<<< Test")
        }
    }

    Context "In GitHub Actions" {
        BeforeAll {
            Mock IsGH { $True }
        }

        It "Writes open and close tags" {
            Use-CidLogGroup -Message "Test" {} 6>&1 | Should -Be @("::group::{Test}", "::endgroup::")
        }
    }
}
