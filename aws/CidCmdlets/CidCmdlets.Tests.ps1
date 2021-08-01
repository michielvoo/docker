BeforeAll {
    Import-Module -Name "./CidCmdlets/"
    $CidContext = Get-Variable -Name "CidContext"
}

Describe "CidCmdlets Module" {
    It "Exports `$CidContext" {
        $CidContext.Value | Should -Be "test"
    }

    It "`$CidContext is constant" {
        $Constant = [System.Management.Automation.ScopedItemOptions]::Constant

        ($CidContext.Options -band $Constant) -eq $Constant | Should -Be $True
    }
}