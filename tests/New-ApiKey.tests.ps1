$IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

Describe 'New-ApiKey' {
        
    BeforeAll {
        . $PSCommandPath.Replace('.tests.ps1','.ps1').Replace('tests', 'functions')

        function Invoke-Method ($Method = 'Get', $Path, $Body) { }
    }

    It 'Requires a UserId to be supplied' -Skip:$IsInteractive {
        { New-ApiKey -Confirm:$false } | Should -Throw
    }

    It 'Requires UserId to be positive' {
        { New-ApiKey -UserId -1 -Confirm:$false } | Should -Throw
    }

    It 'Requires UserId to be Int32' {
        { New-ApiKey -UserId 'a' -Confirm:$false } | Should -Throw
    }

    It 'Hits the correct endpoint' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/users/\d+/keys' }
        New-ApiKey -UserId 6 -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Uses the correct method' {
        Mock Invoke-Method { } -ParameterFilter { $Method -eq 'Put' }
        New-ApiKey -UserId 6 -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the UserId' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/6/' }
        New-ApiKey -UserId 6 -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Does nothing when given -WhatIf' {
        Mock Invoke-Method { }
        New-ApiKey -UserId 6 -WhatIf
        Should -Invoke Invoke-Method -Exactly 0
    }
}
