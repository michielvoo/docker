BeforeAll { 
    . $PSScriptRoot/Environment.ps1
}

Describe "Get-CidEnvironment" {
    BeforeAll {
        Function git
        {
            $LastExitCode = 1
        }
    }

    Context "When running locally" {
        BeforeAll {
            Mock Get-Location { "/test" }
        }

        It "Sets artifacts path to local directory" {
            (Get-CidEnvironment).ArtifactsPath | Should -Be "/test/artifacts"
        }
    }

    Context "When not in a Git repository" {
        
    }
}