BeforeDiscovery {
    Set-Variable "testCases" (Get-DockerTestCases "$PSScriptRoot/Dockerfile")
}

Describe "<metadata.name>:<variant.version> on <platform>" -ForEach $testCases {
    BeforeAll {
        $tag = "$($metadata.Name):test"

        $build = "docker build"
        foreach ($buildArg in $variant.BuildArgs.GetEnumerator()) {
            $build += " --build-arg ""$($buildArg.Name)=$($buildArg.Value)"""
        }
        $build += " --file ""$($metadata.Dockerfile)"""
        $build += " --platform ""$platform"""
        $build += " --tag ""$tag"""
        $build += " ""$($metadata.Directory)"""

        Write-Warning $build
    
        Invoke-Expression $build

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