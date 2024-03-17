BeforeAll {
    Import-Module "$PSScriptRoot/../Utilities.psm1"

    $tag = Get-DockerImageTag $PSScriptRoot "test"

    docker build "$PSScriptRoot" --tag "$tag" 2>&1 >$null
}

AfterAll {
    docker image rm --force "$tag"
}

Describe "az" {
    It "has pwsh as its entrypoint" {
        # Arrange

        # Act
        $output = docker run --rm "$tag" -Version

        # Assert
        $output | Should -Match "PowerShell 7\.2\.\d+"
    }
}