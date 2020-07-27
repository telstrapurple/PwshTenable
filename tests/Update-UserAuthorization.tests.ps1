$IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

Describe 'Update-UserAuthorization' {
        
    BeforeAll {
        . $PSCommandPath.Replace('.tests.ps1','.ps1').Replace('tests', 'functions')

        function Invoke-Method ($Method = 'Get', $Path, $Body) { }
    }

    It 'Requires a UserUuid to be supplied' -Skip:$IsInteractive {
        { Update-UserAuthorization -ApiPermitted $true -PasswordPermitted $true -SamlPermitted $true } | Should -Throw
    }

    It 'Requires UserUuid to be a guid' {
        { Update-UserAuthorization -UserUuid 'a' -ApiPermitted $true -PasswordPermitted $true -SamlPermitted $true } | Should -Throw
        { Update-UserAuthorization -UserUuid 1 -ApiPermitted $true -PasswordPermitted $true -SamlPermitted $true } | Should -Throw
    }

    It 'Requires ApiPermitted to be supplied' -Skip:$IsInteractive {
        { Update-UserAuthorization -UserUuid 'd64aa936-e63f-4227-a394-1699425f07e1' -PasswordPermitted $true -SamlPermitted $true } | Should -Throw
    }

    It 'Requires ApiPermitted to be a bool' {
        { Update-UserAuthorization -UserUuid 'd64aa936-e63f-4227-a394-1699425f07e1' -ApiPermitted 'a' -PasswordPermitted $true -SamlPermitted $true } | Should -Throw
    }

    It 'Requires a PasswordPermitted to be supplied' -Skip:$IsInteractive {
        { Update-UserAuthorization -UserUuid 'd64aa936-e63f-4227-a394-1699425f07e1' -ApiPermitted $true -SamlPermitted $true } | Should -Throw
    }

    It 'Requires PasswordPermitted to be a bool' {
        { Update-UserAuthorization -UserUuid 'd64aa936-e63f-4227-a394-1699425f07e1' -ApiPermitted $true -PasswordPermitted 'a' -SamlPermitted $true } | Should -Throw
    }

    It 'Requires a SamlPermitted to be supplied' -Skip:$IsInteractive {
        { Update-UserAuthorization -UserUuid 'd64aa936-e63f-4227-a394-1699425f07e1' -ApiPermitted $true -PasswordPermitted $true } | Should -Throw
    }

    It 'Requires SamlPermitted to be a bool' {
        { Update-UserAuthorization -UserUuid 'd64aa936-e63f-4227-a394-1699425f07e1' -ApiPermitted $true -PasswordPermitted $true -SamlPermitted 'a' } | Should -Throw
    }

    It 'Hits the correct endpoint' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/users/[0-9a-fA-F\-]{36}/authorizations' }
        Update-UserAuthorization -UserUuid 'd64aa936-e63f-4227-a394-1699425f07e1' -ApiPermitted $true -PasswordPermitted $true -SamlPermitted $true
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Uses the correct method' {
        Mock Invoke-Method { } -ParameterFilter { $Method -eq 'Put' }
        Update-UserAuthorization -UserUuid 'd64aa936-e63f-4227-a394-1699425f07e1' -ApiPermitted $true -PasswordPermitted $true -SamlPermitted $true
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the UserUuid' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/d64aa936-e63f-4227-a394-1699425f07e1/' }
        Update-UserAuthorization -UserUuid 'd64aa936-e63f-4227-a394-1699425f07e1' -ApiPermitted $true -PasswordPermitted $true -SamlPermitted $true
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Pass on the Options A:<A> P:<P> S:<S>' -TestCases @(
        @{ A = $true;  P = $true;  S = $true  }
        @{ A = $true;  P = $true;  S = $false }
        @{ A = $true;  P = $false; S = $true  }
        @{ A = $true;  P = $false; S = $false }
        @{ A = $false; P = $true;  S = $true  }
        @{ A = $false; P = $true;  S = $false }
        @{ A = $false; P = $false; S = $true  }
        @{ A = $false; P = $false; S = $false }
    ) {
        Mock Invoke-Method { } -ParameterFilter { $Body.api_permitted -eq $A -and $Body.password_permitted -eq $P -and $Body.saml_permitted -eq $S }
        Update-UserAuthorization -UserUuid 'd64aa936-e63f-4227-a394-1699425f07e1' -ApiPermitted $A -PasswordPermitted $P -SamlPermitted $S
        Should -Invoke Invoke-Method -Exactly 1
    }
}
