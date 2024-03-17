BeforeAll {
    Import-Module "$PSScriptRoot/../Utilities.psm1"

    $tag = Get-DockerImageTag $PSScriptRoot "test"

    docker build "$PSScriptRoot" --tag "$tag" 2>&1 > $null
}

AfterAll {
    docker image rm --force "$tag"
}

Describe "hugo" {
    It "has hugo as its entrypoint" {
        # Act
        $output = docker run --rm "$tag" version

        # Assert
        $output | Should -Match "hugo v0.120.4\+extended .+"
    }

    It "has Git" {
        # Act
        $output = docker run --rm --entrypoint "git" "$tag" --version

        # Assert
        $output | Should -Match "git version 2\.43\..+"
    }
}