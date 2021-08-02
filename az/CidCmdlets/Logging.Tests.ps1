BeforeAll {
    . $PSScriptRoot/Logging.ps1
    $global:CidContext = @{}
    $CidContext.Runner = "local"
}

Describe "Use-CidLogGroup" {
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

    It "Takes message from pipeline" {
        "Test" | Use-CidLogGroup -ScriptBlock {} 6>&1 | Should -Be @(
            ">>> Test >>>"
            "<<< Test <<<"
        )
    }

    It "Takes script block from pipeline" {
        {} | Use-CidLogGroup "Test" 6>&1 | Should -Be @(
            ">>> Test >>>"
            "<<< Test <<<"
        )
    }

    Context "Azure DevOps (Server) Pipelines" {
        BeforeAll {
            $CidContext.Runner = "az"
        }

        It "Writes open and close tags" {
            Use-CidLogGroup -Message "Test" {} 6>&1 | Should -Be @(
                "##[group]Test"
                "##[endgroup]"
            )
        }
    }

    Context "Bitbucket Pipelines" {
        BeforeAll {
            $CidContext.Runner = "bit"
        }

        It "Writes open and close tags" {
            Use-CidLogGroup -Message "Test" {} 6>&1 | Should -Be @(
                "Test"
                ""
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

    Context "GitLab CI/CD Pipelines" {
        BeforeAll {
            $CidContext.Runner = "gl"
        }

        It "Writes open and close tags" {
            Use-CidLogGroup -Message "Test" {} 6>&1 | Should -Be @(
                "Test"
                ""
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

Describe "Write-CidLogHeader" {
    It "Writes header" {
        Write-CidLogHeader -Message "Test" 6>&1 | Should -Be @(
            "### Test ###"
        )
    }

    It "Takes message from pipeline" {
        "Test" | Write-CidLogHeader 6>&1 | Should -Be @(
            "### Test ###"
        )
    }
}
