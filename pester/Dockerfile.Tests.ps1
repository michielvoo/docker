BeforeAll {
    Import-Module "$PSScriptRoot/../Utilities.psm1"

    $tag = Get-DockerImageTag $PSScriptRoot "test"

    docker build "$PSScriptRoot" --tag "$tag" 2>&1 > $null
}

AfterAll {
    docker image rm --force "$tag"
}

Describe "pester" {
    It "has Invoke-Pester as its entrypoint" {
        # Act
        $output = docker run --rm "$tag" 

        # Assert
        $output[0] | Should -Match "System.Management.Automation.RuntimeException: No test files were found and no scriptblocks were provided.+"
    }
}