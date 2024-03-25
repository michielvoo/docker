BeforeAll {
    $metadata = Get-DockerMetadata "$PSScriptRoot/Dockerfile"

    $tag = "$($metadata.Name):test"

    docker build --platform "linux/amd64" --tag "$tag" "$($metadata.Directory)"
}

AfterAll {
    docker image rm --force "$tag"
}

Describe "pester" {
    It "has Pester" {
        # Act
        $output = docker run --entrypoint pwsh --rm "$tag" -Command "(Get-Module Pester).Version.ToString()"

        # Assert
        $output | Should -Match "5\.\d+\.\d+"
    }

    It "has Invoke-Pester as its entrypoint" {
        # Act
        $output = docker run --rm "$tag" 

        # Assert
        $output[0] | Should -Match "System.Management.Automation.RuntimeException: No test files were found and no scriptblocks were provided.+"
    }
}
