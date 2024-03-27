@{
    Labels = @{
        "org.opencontainers.image.title" = "PowerShell SDK"
        "org.opencontainers.image.description" = "PowerShell, for development of PowerShell modules"
    }
    Variants = @(
        @{
            BuildArgs = @{
                PS_VERSION = "lts-7.2"
            }
            Version = "7.2"
            Platforms = @("linux/amd64", "linux/arm64")
        }
        @{
            BuildArgs = @{
                PS_VERSION = "7.4"
            }
            Version = "7.4"
            Platforms = @("linux/amd64", "linux/arm64")
        }
    )
}