$IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

Describe 'Get-User' {
        
    BeforeAll {
        . $PSCommandPath.Replace('.tests.ps1','.ps1').Replace('tests', 'functions')

        function Invoke-Method ($Method = 'Get', $Path, $Body) { }
    }

    It 'Allows no parameters to be passed' -Skip:$IsInteractive {
        Mock Invoke-Method { }
        Get-User
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Allows UserId to be passed' -Skip:$IsInteractive {
        Mock Invoke-Method { }
        Get-User -UserId 6
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Allows UserUuid to be passed' -Skip:$IsInteractive {
        Mock Invoke-Method { }
        Get-User -UserUuid 'd64aa936-e63f-4227-a394-1699425f07e1'
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Does not allows UserId and UserUuid to be passed' -Skip:$IsInteractive {
        { Get-User -UserId 6 -UserUuid 'd64aa936-e63f-4227-a394-1699425f07e1' } | Should -Throw
    }

    It 'Requires UserId to be positive' {
        { Get-User -UserId -1 } | Should -Throw
    }

    It 'Requires UserId to be Int32' {
        { Get-User -UserId 'a' } | Should -Throw
    }

    It 'Requires UserUuid to a guid' {
        { Get-User -UserUuid -1 } | Should -Throw
        { Get-User -UserUuid 'a' } | Should -Throw
    }

    It 'Hits the correct endpoint - all' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/users$' }
        Get-User
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Hits the correct endpoint - UserId' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/users/\d+$' }
        Get-User -UserId 6
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Hits the correct endpoint - UserUuid' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/users/[0-9a-fA-F\-]{36}$' }
        Get-User -UserUuid 'd64aa936-e63f-4227-a394-1699425f07e1'
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Uses the correct method - all' {
        Mock Invoke-Method { } -ParameterFilter { $null -eq $Method -or $Method -eq 'Get' }
        Get-User -UserId 6
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Uses the correct method - UserId' {
        Mock Invoke-Method { } -ParameterFilter { $null -eq $Method -or $Method -eq 'Get' }
        Get-User -UserId 6
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Uses the correct method - UserUuid' {
        Mock Invoke-Method { } -ParameterFilter { $null -eq $Method -or $Method -eq 'Get' }
        Get-User -UserUuid 'd64aa936-e63f-4227-a394-1699425f07e1'
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the UserId' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/6$' }
        Get-User -UserId 6
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the UserUuid' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/d64aa936-e63f-4227-a394-1699425f07e1$' }
        Get-User -UserUuid 'd64aa936-e63f-4227-a394-1699425f07e1'
        Should -Invoke Invoke-Method -Exactly 1
    }
}
