BeforeDiscovery {
    Set-Variable "testCases" (Get-DockerTestCases "$PSScriptRoot/Dockerfile")
}

Describe "hugo-sdk on <platform>" -ForEach $testCases {
    BeforeAll {
        $tag = "$($metadata.Name):test"
    
        docker build --file "$($metadata.Dockerfile)" --platform "$platform" --tag "$tag" "$($metadata.Directory)"
    }

    AfterAll {
        docker image rm --force "$tag"
    }

    It "has hugo as its entrypoint" {
        # Act
        $output = docker run --rm "$tag" version

        # Assert
        $output | Should -Match "hugo v0.120.4\+extended .+"
    }

    It "has Git" {
        # Act
        $output = docker run --entrypoint "git" --rm "$tag" --version

        # Assert
        $output | Should -Match "git version 2\.43\..+"
    }
}