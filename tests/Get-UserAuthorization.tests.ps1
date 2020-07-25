$IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

Describe 'Get-UserAuthorization' {
        
    BeforeAll {
        . $PSCommandPath.Replace('.tests.ps1','.ps1').Replace('tests', 'functions')

        function Invoke-Method ($Method = 'Get', $Path, $Body) { }
    }

    It 'Requires a UserUuid to be supplied' -Skip:$IsInteractive {
        { Get-UserAuthorization } | Should -Throw
    }

    It 'Requires UserUuid to be a guid' {
        { Get-UserAuthorization -UserUuid -1 } | Should -Throw
        { Get-UserAuthorization -UserUuid 'a' } | Should -Throw
    }

    It 'Hits the correct endpoint' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/users/[0-9a-fA-F\-]{36}/authorizations' }
        Get-UserAuthorization -UserUuid 'd64aa936-e63f-4227-a394-1699425f07e1'
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Uses the correct method' {
        Mock Invoke-Method { } -ParameterFilter { $null -eq $Method -or $Method -eq 'Get' }
        Get-UserAuthorization -UserUuid 'd64aa936-e63f-4227-a394-1699425f07e1'
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the UserUuid' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/d64aa936-e63f-4227-a394-1699425f07e1/' }
        Get-UserAuthorization -UserUuid 'd64aa936-e63f-4227-a394-1699425f07e1'
        Should -Invoke Invoke-Method -Exactly 1
    }
}
