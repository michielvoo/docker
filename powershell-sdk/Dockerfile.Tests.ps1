BeforeDiscovery {
    Set-Variable "testCases" (Get-DockerTestCases "$PSScriptRoot/Dockerfile")
}

Describe "<metadata.name> on <platform>" -ForEach $testCases {
    BeforeAll {
        $tag = "$($metadata.Name):test"
    
        docker build --file "$($metadata.Dockerfile)" --platform "$platform" --tag "$tag" "$($metadata.Directory)"

        Set-Variable "containerId" $(docker run --detach --interactive "$tag")
    }

    AfterAll {
        docker stop "$containerId"
        docker rm "$containerId"
        docker image rm --force "$tag"
    }

    It "has Pester" {
        # Act
        $version = docker exec "$containerId" pwsh -Command "(Get-Module Pester).Version.ToString()"

        # Assert
        $version | Should -Match "5\.\d+\.\d+"
    }

    It "has PSScriptAnalyzer" {
        # Act
        $version = docker exec "$containerId" pwsh -Command "(Get-Module PSScriptAnalyzer).Version.ToString()"

        # Assert
        $version | Should -Match "1\.\d+\.\d+"
    }

    It "can be used to exec a command" {
        # Act
        $version = docker exec "$containerId" dotnet --list-runtimes

        # Assert
        $version | Should -BeExactly "Microsoft.NETCore.App 8.0.3 [/usr/share/dotnet/shared/Microsoft.NETCore.App]"
    }
}