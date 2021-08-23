#!/usr/bin/env pwsh
Switch (3) {
    "docs" {
        Write-Host "docs"
    }
    "test" {
        Write-Host "test"
    }
    "version" {
        docker run --rm -it --entrypoint git hugo --version
        docker run --rm -it hugo version
    }
}
