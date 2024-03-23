BeforeDiscovery {
    $targetPlatforms = @(
        @{ Platform = "linux/amd64" }
        @{ Platform = "linux/arm64" }
    )
}

Describe "hugo-sdk on <platform>" -ForEach $targetPlatforms {
    BeforeAll {
        Import-Module "$PSScriptRoot/../Utilities.psm1"

        $tag = Get-DockerImageTag $PSScriptRoot "test"
    
        docker build --platform "$platform" --tag "$tag" "$PSScriptRoot"
    }

    AfterAll {
        docker image rm --force "$tag"
    }

    It "has hugo as its entrypoint" {
        # Act
        $output = docker run --platform "$platform" --rm "$tag" version

        # Assert
        $output | Should -Match "hugo v0.120.4\+extended .+"
    }

    It "has Git" {
        # Act
        $output = docker run --entrypoint "git" --platform "$platform" --rm "$tag" --version

        # Assert
        $output | Should -Match "git version 2\.43\..+"
    }
}