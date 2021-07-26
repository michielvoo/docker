BeforeAll { 
    . $PSScriptRoot/example.ps1
}

Describe "Test-Example" {
    It "Returns true" -Tag "unit" {
        Test-Example | Should -Be $True
    }
}
