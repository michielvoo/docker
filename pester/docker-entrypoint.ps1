#! /usr/bin/pwsh
Invoke-Pester -Configuration @{ Output = @{ Verbosity = "Detailed" } } @Args