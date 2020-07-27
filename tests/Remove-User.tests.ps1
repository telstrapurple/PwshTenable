$IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

Describe 'Remove-User' {
        
    BeforeAll {
        . $PSCommandPath.Replace('.tests.ps1','.ps1').Replace('tests', 'functions')

        function Invoke-Method ($Method = 'Get', $Path, $Body) { }
    }

    It 'Requires a UserId or UserUuid to be supplied' -Skip:$IsInteractive {
        { Remove-User -Confirm:$false } | Should -Throw
    }

    It 'Requires UserId to be positive' {
        { Remove-User -UserId -1 -Confirm:$false } | Should -Throw
    }

    It 'Requires UserId to be Int32' {
        { Remove-User -UserId 'a' -Confirm:$false } | Should -Throw
    }

    It 'Requires UserUuid to a guid' {
        { Remove-User -UserUuid -1 -Confirm:$false } | Should -Throw
        { Remove-User -UserUuid 'a' -Confirm:$false } | Should -Throw
    }

    It 'Hits the correct endpoint' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/users/\d+' }
        Remove-User -UserId 6 -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Uses the correct method' {
        Mock Invoke-Method { } -ParameterFilter { $Method -eq 'Delete' }
        Remove-User -UserId 6 -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the UserId' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/6$' }
        Remove-User -UserId 6 -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the UserUuid' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/d64aa936-e63f-4227-a394-1699425f07e1$' }
        Remove-User -UserUuid 'd64aa936-e63f-4227-a394-1699425f07e1' -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Does nothing when given -WhatIf' {
        Mock Invoke-Method { }
        Remove-User -UserUuid 'd64aa936-e63f-4227-a394-1699425f07e1' -WhatIf
        Should -Invoke Invoke-Method -Exactly 0
    }
}
