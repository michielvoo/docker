BeforeAll {
    $name = Split-Path "$PSScriptRoot" -Leaf

    $ancestor = Split-Path "$PSScriptRoot" -Parent
    while ($true) {
        if (Get-ChildItem $ancestor "License.txt") {
            if ($Env:GITHUB_REPOSITORY) {
                $name = "$("$Env:GITHUB_REPOSITORY".Split("/")[0])/$name"
            }
            else {
                $ancestor = Split-Path $ancestor -Parent
                $name = "$(Split-Path $ancestor -Leaf)/$name"
            }

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

Describe "pester" {
    It "has Pester as its entrypoint" {
        # Arrange

        # Act
        $output = docker run --rm "$tag"

        # Assert
        $output | Should -Match "System.Management.Automation.RuntimeException: No test files were found and no scriptblocks were provided.+"
    }
}