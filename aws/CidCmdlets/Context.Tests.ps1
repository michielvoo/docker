BeforeAll { 
    . $PSScriptRoot/Context.ps1
}

Describe "Get-CidContext" {
    BeforeAll {
        Function git
        {
            $LastExitCode = 1
        }
    }

    It "Returns artifacts path, run, and runner" {
        (Get-CidContext).ArtifactsPath | Should -Be (Join-Path -Path (Get-Location) -ChildPath "artifacts")
        (Get-CidContext).Run | Should -Match "^\d{8}T\d{6}\d+Z"
        (Get-CidContext).Runner | Should -Be "manual"
    }

    It "Returns commit, name, and SCM" {
        (Get-CidContext).Commit | Should -Be "none"
        (Get-CidContext).Name | Should -Be (Split-Path -Path (Get-Location) -Leaf)
        (Get-CidContext).Scm | Should -Be "none"
    }

    It "Returns deployment" {
        $CidContext = Get-CidContext
        $CidContext.Deployment | Should -Be "$($CidContext.Name)-$($CidContext.Scm)$($CidContext.Commit)-$($CidContext.Runner)$($CidContext.Run)"
    }

    It "Returns environment" {
        (Get-CidContext).Environment | Should -Be "dev"
    }

    Context "Azure Pipelines" {
        BeforeAll {
            Mock Test-Path { $True } -ParameterFilter { $Path -eq "Env:TF_BUILD" }
            $Env:BUILD_BINARIESDIRECTORY = "/home/vsts/work/1/b"
            $Env:BUILD_BUILDID = "20210718.12"
        }

        It "Returns artifacts path, run, and runner" {
            (Get-CidContext).ArtifactsPath | Should -Be "/home/vsts/work/1/b"
            (Get-CidContext).Run | Should -Be "20210718.12"
            (Get-CidContext).Runner | Should -Be "tf"
        }

        AfterAll {
            Remove-Item -Path "Env:BUILD_BINARIESDIRECTORY"
            Remove-Item -Path "Env:BUILD_BUILDID"
        }
    }

    Context "Git" {
        BeforeAll {
            Mock git { "https://example.com/application.git" } -ParameterFilter { $Args[0] -eq "config" -and $Args[1] -eq "--get" -and $Args[2] -eq "remote.origin.url" }
            Mock git { "c4bbc3d37aff" } -ParameterFilter { $Args[0] -eq "rev-parse" -and $Args[1] -eq "HEAD" }
        }

        BeforeEach {
            Mock git { Set-Variable -Scope "global" -Name "LastExitCode" -Value 0 } -ParameterFilter { $Args.Count -eq 1 -and $Args[0] -eq "rev-parse" }
        }

        It "Returns commit, name, and SCM" {
            (Get-CidContext).Commit | Should -Be "c4bbc3d37aff"
            (Get-CidContext).Name | Should -Be "application"
            (Get-CidContext).Scm | Should -Be "git"
        }

        AfterEach {
            Remove-Variable -Scope "global" -Name "LastExitCode"
        }
    }

    Context "GitHub Actions" {
        BeforeAll {
            Mock Test-Path { $True } -ParameterFilter { $Path -eq "Env:GITHUB_ACTION" }
        }

        It "Returns artifacts path, run, and runner" {
            (Get-CidContext).Runner | Should -Be "gh"
        }
    }

    Context "TeamCity" {
        BeforeAll {
            Mock Test-Path { $True } -ParameterFilter { $Path -eq "Env:TEAMCITY_VERSION" }
        }

        It "Returns artifacts path, run, and runner" {
            (Get-CidContext).Runner | Should -Be "tc"
        }
    }

    Context "With environment variables set" {
        BeforeEach {
            Mock Get-CidContextFromRunner { @{ ArtifactsPath = "ArtifactsPath from runner"; Run = "Run from runner"; Runner = "Runner from runner" } }
            Mock Get-CidContextFromScm { @{ Commit = "Commit from SCM"; Name = "Name from SCM"; Scm = "Scm from SCM" } }

            $Env:CID_ARTIFACTS_PATH = "ArtifactsPath from environment variables"
            $Env:CID_COMMIT = "Commit from environment variables"
            $Env:CID_DEPLOYMENT = "Deployment from environment variables"
            $Env:CID_ENVIRONMENT = "Environment from environment variables"
            $Env:CID_NAME = "Name from environment variables"
            $Env:CID_RUN = "Run from environment variables"
            $Env:CID_RUNNER = "Runner from environment variables"
            $Env:CID_SCM = "Scm from environment variables"
        }

        It "Return artifacts path, commit, deployment, environment, name, run, runner, and scm from environment variables" {
            $CidContext = Get-CidContext
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
