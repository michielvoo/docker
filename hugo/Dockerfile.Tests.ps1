BeforeAll {
    $name = Split-Path "$PSScriptRoot" -Leaf

    $ancestor = Split-Path "$PSScriptRoot" -Parent
    while ($true) {
        if (Get-ChildItem $ancestor "License.txt") {
            $ancestor = Split-Path $ancestor -Parent
            $name = "$(Split-Path $ancestor -Leaf)/$name"
            break
        }

        $name = "$(Split-Path $ancestor -Leaf)/$name"
        $ancestor = Split-Path $ancestor -Parent
    }

    $tag = "$name`:test"

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