BeforeAll { 
    . $PSScriptRoot/Logging.ps1
}

Describe "Use-CidLogGroup" {
    It "Returns the script block's return value" {
        $Result = Use-CidLogGroup -Message "Test" {
            42
        }
        $Result | Should -Be 42
    }
}
