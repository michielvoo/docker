BeforeAll {
    . $PSScriptRoot/Logging.ps1
    $global:CidContext = @{}
}

Describe "Use-CidLogGroup" {
    BeforeAll {
        $CidContext.Runner = "manual"
    }

    It "Returns the script block's return value" {
        $Result = Use-CidLogGroup -Message "Test" {
            42
        } 6>$Null
        $Result | Should -Be 42
    }

    It "Writes open and close tags" {
        Use-CidLogGroup -Message "Test" {} 6>&1 | Should -Be @(
            ">>> Test >>>"
            "<<< Test <<<"
        )
    }

    Context "Azure Pipelines" {
        BeforeAll {
            $CidContext.Runner = "tf"
        }

        It "Writes open and close tags" {
            Use-CidLogGroup -Message "Test" {} 6>&1 | Should -Be @(
                "##[group]Test"
                "##[endgroup]"
            )
        }
    }

    Context "GitHub Actions" {
        BeforeAll {
            $CidContext.Runner = "gh"
        }

        It "Writes open and close tags" {
            Use-CidLogGroup -Message "Test" {} 6>&1 | Should -Be @(
                "::group::{Test}"
                "::endgroup::"
            )
        }
    }

    Context "TeamCity" {
        BeforeAll {
            $CidContext.Runner = "tc"
        }

        It "Writes open and close tags" {
            Use-CidLogGroup -Message "Test" {} 6>&1 | Should -Be @(
                "##teamcity[blockOpened name='Test' description='']"
                "##teamcity[blockClosed name='Test']"
            )
        }
    }
}
