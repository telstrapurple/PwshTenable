$IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

Describe 'Enable-User' {
        
    BeforeAll {
        . $PSCommandPath.Replace('.tests.ps1','.ps1').Replace('tests', 'functions')

        function Invoke-Method ($Method = 'Get', $Path, $Body) { }
    }

    It 'Requires a UserId to be supplied' -Skip:$IsInteractive {
        { Enable-User } | Should -Throw
    }

    It 'Requires UserId to be positive' {
        { Enable-User -UserId -1 } | Should -Throw
    }

    It 'Requires UserId to be Int32' {
        { Enable-User -UserId 'a' } | Should -Throw
    }

    It 'Hits the correct endpoint' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/users/\d+/enabled' }
        Enable-User -UserId 6
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Uses the correct method' {
        Mock Invoke-Method { } -ParameterFilter { $Method -eq 'Put' }
        Enable-User -UserId 6
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the UserId' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/6/' }
        Enable-User -UserId 6
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Has correct body' {
        Mock Invoke-Method { } -ParameterFilter { $Body.enabled -eq $true }
        Enable-User -UserId 6
        Should -Invoke Invoke-Method -Exactly 1
    }
}
