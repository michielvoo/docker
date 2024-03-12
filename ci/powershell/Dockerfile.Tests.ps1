BeforeAll {
    $tag = [System.Guid]::NewGuid().ToString("N")
    docker build "$PSScriptRoot" --tag "$tag" 2>&1 > $null
    docker run --detach --interactive --name "$tag" "$tag" 2>&1 > $null
}

AfterAll {
    docker stop "$tag"
    docker rm "$tag"
    docker image rm --force "$tag"
}

Describe "ci/powershell" {
    It "can be used to exec a command" {
        # Act
        $version = docker exec "$tag" dotnet --list-runtimes

        # Assert
        $version | Should -BeExactly "Microsoft.NETCore.App 8.0.3 [/usr/share/dotnet/shared/Microsoft.NETCore.App]"
    }
}