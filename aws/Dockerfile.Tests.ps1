BeforeAll {
    $metadata = Get-DockerMetadata "$PSScriptRoot/Dockerfile"

    $tag = "$($metadata.Name):test"

    docker build --platform "linux/amd64" --tag "$tag" "$($metadata.Directory)"
}

AfterAll {
    docker image rm --force "$tag"
}

Describe "aws" {
    It "has pwsh as its entrypoint" {
        # Arrange

        # Act
        $output = docker run --rm "$tag" -Version

        # Assert
        $output | Should -Match "PowerShell 7\.2\.\d+"
    }
}