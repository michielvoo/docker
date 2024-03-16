BeforeAll {
    $tag = [System.Guid]::NewGuid().ToString("N")
    docker build "$PSScriptRoot" --tag "$tag" 2>&1 > $null
}

AfterAll {
    docker image rm --force "$tag"
}

Describe "hugo" {
    It "has hugo as its entrypoint" {
        # Arrange

        # Act
        $output = docker run --rm "$tag" version

        # Assert
        $output | Should -Match "hugo v0.120.4\+extended .+"
    }
}