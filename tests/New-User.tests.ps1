$IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

Describe 'New-User' {
        
    BeforeAll {
        . $PSCommandPath.Replace('.tests.ps1','.ps1').Replace('tests', 'functions')

        function Invoke-Method ($Method = 'Get', $Path, $Body) { }
    }

    It 'Requires Username to be supplied' -Skip:$IsInteractive {
        { New-User -Confirm:$false } | Should -Throw
    }

    It 'Requires Username to be an email' {
        { New-User -Username -1 -Confirm:$false } | Should -Throw
        { New-User -Username 'a' -Confirm:$false } | Should -Throw
    }

    It 'Requires Password to be a [SecureString]' {
        { New-User -Username 'name@company.net' -Password 2 -Confirm:$false } | Should -Throw
        { New-User -Username 'name@company.net' -Password 'pass' -Confirm:$false } | Should -Throw
    }

    It 'Requires Permission to be a [Int32]' {
        { New-User -Username 'name@company.net' -Permission 'a' -Confirm:$false } | Should -Throw
    }

    It 'Requires Permission to be at least 16' {
        { New-User -Username 'name@company.net' -Permission -1 -Confirm:$false } | Should -Throw
        { New-User -Username 'name@company.net' -Permission 0 -Confirm:$false } | Should -Throw
        { New-User -Username 'name@company.net' -Permission 1 -Confirm:$false } | Should -Throw
        { New-User -Username 'name@company.net' -Permission 15 -Confirm:$false } | Should -Throw
    }

    It 'Requires Permission to be at most 64' {
        { New-User -Username 'name@company.net' -Permission 65 -Confirm:$false } | Should -Throw
        { New-User -Username 'name@company.net' -Permission 128 -Confirm:$false } | Should -Throw
    }

    It 'Requires Email to be an email' {
        { New-User -Username 'name@company.net' -Email -1 -Confirm:$false } | Should -Throw
        { New-User -Username 'name@company.net' -Email 'a' -Confirm:$false } | Should -Throw
    }

    It 'Hits the correct endpoint' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/users$' }
        New-User -Username 'name@company.net' -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Uses the correct method' {
        Mock Invoke-Method { } -ParameterFilter { $Method -eq 'Post' }
        New-User -Username 'name@company.net' -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the Username' {
        Mock Invoke-Method { } -ParameterFilter { $Body.username -eq 'name@company.net' }
        New-User -Username 'name@company.net' -Confirm:$false 
        Should -Invoke Invoke-Method -Exactly 1
    }
}
