BeforeAll{
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
    $containerId = docker run --detach --interactive "$tag"
}

AfterAll {
    docker stop "$containerId"
    docker rm "$containerId"
    docker image rm --force "$tag"
}

Describe "ci/powershell" {
    It "can be used to exec a command" {
        # Act
        $version = docker exec "$containerId" dotnet --list-runtimes

        # Assert
        $version | Should -BeExactly "Microsoft.NETCore.App 8.0.3 [/usr/share/dotnet/shared/Microsoft.NETCore.App]"
    }
}