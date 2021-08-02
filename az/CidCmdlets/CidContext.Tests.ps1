BeforeAll { 
    . $PSScriptRoot/CidContext.ps1
}

Describe "Get-CidContext" {
    BeforeAll {
        Function git
        {
            $LastExitCode = 1
        }

        $CidContext = Get-CidContext
    }

    It "Returns artifacts path, run, and runner" {
        $CidContext.ArtifactsPath | Should -Be (Join-Path -Path (Get-Location) -ChildPath "artifacts")
        $CidContext.Run | Should -Match "^\d{8}T\d{6}\d+Z"
        $CidContext.Runner | Should -Be "local"
    }

    It "Returns commit, name, and SCM" {
        $CidContext.Commit | Should -Be "unknown"
        $CidContext.Name | Should -Be (Split-Path -Path (Get-Location) -Leaf)
        $CidContext.Scm | Should -Be $Null
    }

    It "Returns deployment" {
        $CidContext.Deployment | Should -Be "$($CidContext.Name)-$($CidContext.Scm)$($CidContext.Commit)-$($CidContext.Runner)$($CidContext.Run)"
    }

    It "Returns environment" {
        $CidContext.Environment | Should -Be "dev"
    }

    Context "Azure Pipelines" {
        BeforeAll {
            $Env:BUILD_BINARIESDIRECTORY = "/home/vsts/work/1/b"
            $Env:BUILD_BUILDID = "27534"
        }

        It "Returns artifacts path, run, and runner" {
            $CidContext = Get-CidContext

            $CidContext.ArtifactsPath | Should -Be "/home/vsts/work/1/b"
            $CidContext.Run | Should -Be "27534"
            $CidContext.Runner | Should -Be "tf"
        }

        AfterAll {
            Remove-Item -Path "Env:BUILD_BINARIESDIRECTORY"
            Remove-Item -Path "Env:BUILD_BUILDID"
        }
    }

    Context "Bitbucket Pipelines" {
        BeforeAll {
            $Env:BITBUCKET_BUILD_NUMBER = "27534"
        }

        It "Returns run and runner" {
            $CidContext = Get-CidContext

            $CidContext.Run | Should -Be "27534"
            $CidContext.Runner | Should -Be "bit"
        }

        AfterAll {
            Remove-Item -Path "Env:BITBUCKET_BUILD_NUMBER"
        }
    }

    Context "Git" {
        BeforeAll {
            Mock git { "https://example.com/application.git" } -ParameterFilter { $Args[0] -eq "config" -and $Args[1] -eq "--get" -and $Args[2] -eq "remote.origin.url" }
            Mock git { "c4bbc3d37aff" } -ParameterFilter { $Args[0] -eq "rev-parse" -and $Args[1] -eq "HEAD" }
        }

        BeforeEach {
            Mock git { Set-Variable -Scope "global" -Name "LastExitCode" -Value 0 } -ParameterFilter { $Args.Count -eq 1 -and $Args[0] -eq "rev-parse" }

            $CidContext = Get-CidContext
        }

        It "Returns commit, name, and SCM" {
            $CidContext.Commit | Should -Be "c4bbc3d37aff"
            $CidContext.Name | Should -Be "application"
            $CidContext.Scm | Should -Be "git"
            $CidContext.Deployment | Should -Match "-gitc4bbc3d37aff-"
        }

        AfterEach {
            Remove-Variable -Scope "global" -Name "LastExitCode"
        }
    }

    Context "GitHub Actions" {
        BeforeAll {
            $Env:GITHUB_RUN_ID = "27534"
        }

        It "Returns run and runner" {
            $CidContext = Get-CidContext

            $CidContext.Run | Should -Be "27534"
            $CidContext.Runner | Should -Be "gh"
        }

        AfterAll {
            Remove-Item -Path "Env:GITHUB_RUN_ID"
        }
    }

    Context "TeamCity" {
        BeforeAll {
            $Env:BUILD_NUMBER = "27534"
        }

        It "Returns run and runner" {
            $CidContext = Get-CidContext

            $CidContext.Run | Should -Be "27534"
            $CidContext.Runner | Should -Be "tc"
        }

        AfterAll {
            Remove-Item -Path "Env:BUILD_NUMBER"
        }
    }

    Context "With environment variables set" {
        BeforeEach {
            Mock Get-CidContextFromScm { @{ Commit = "Commit from SCM"; Name = "Name from SCM"; Scm = "Scm from SCM" } }

            $Env:CID_ARTIFACTS_PATH = "ArtifactsPath from environment variables"
            $Env:CID_COMMIT = "Commit from environment variables"
            $Env:CID_DEPLOYMENT = "Deployment from environment variables"
            $Env:CID_ENVIRONMENT = "Environment from environment variables"
            $Env:CID_NAME = "Name from environment variables"
            $Env:CID_RUN = "Run from environment variables"
            $Env:CID_RUNNER = "Runner from environment variables"
            $Env:CID_SCM = "Scm from environment variables"

            $CidContext = Get-CidContext
        }

        It "Return artifacts path, commit, deployment, environment, name, run, runner, and scm from environment variables" {
            $CidContext.ArtifactsPath | Should -Be "ArtifactsPath from environment variables"
            $CidContext.Commit | Should -Be "Commit from environment variables"
            $CidContext.Deployment | Should -Be "Deployment from environment variables"
            $CidContext.Environment | Should -Be "Environment from environment variables"
            $CidContext.Name | Should -Be "Name from environment variables"
            $CidContext.Run | Should -Be "Run from environment variables"
            $CidContext.Runner | Should -Be "Runner from environment variables"
            $CidContext.Scm | Should -Be "Scm from environment variables"
        }

        AfterEach {
            Remove-Item -Path "Env:CID_ARTIFACTS_PATH"
            Remove-Item -Path "Env:CID_COMMIT"
            Remove-Item -Path "Env:CID_DEPLOYMENT"
            Remove-Item -Path "Env:CID_ENVIRONMENT"
            Remove-Item -Path "Env:CID_NAME"
            Remove-Item -Path "Env:CID_RUN"
            Remove-Item -Path "Env:CID_RUNNER"
            Remove-Item -Path "Env:CID_SCM"
        }
    }
}
