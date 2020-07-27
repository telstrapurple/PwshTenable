$IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

Describe 'Update-User' {
        
    BeforeAll {
        . $PSCommandPath.Replace('.tests.ps1','.ps1').Replace('tests', 'functions')

        function Invoke-Method ($Method = 'Get', $Path, $Body) { }
    }

    It 'Requires a UserId or UserUuid to be supplied' -Skip:$IsInteractive {
        { Update-User -Permission 32 -Confirm:$false } | Should -Throw
    }

    It 'Requires UserId to be positive' {
        { Update-User -UserId -1 -Permission 32 -Confirm:$false } | Should -Throw
    }

    It 'Requires UserId to be Int32' {
        { Update-User -UserId 'a' -Permission 32 -Confirm:$false } | Should -Throw
    }

    It 'Requires UserUuid to a guid' {
        { Update-User -UserUuid -1 -Permission 32 -Confirm:$false } | Should -Throw
        { Update-User -UserUuid 'a' -Permission 32 -Confirm:$false } | Should -Throw
    }

    It 'Requires Permission to be supplied' -Skip:$IsInteractive {
        { Update-User -UserId 6 -Confirm:$false } | Should -Throw
    }

    It 'Requires Permission to be a [Int32]' {
        { Update-User -UserId 6 -Permission 'a' -Confirm:$false } | Should -Throw
    }

    It 'Requires Permission to be at least 16' {
        { Update-User -UserId 6 -Permission -1 -Confirm:$false } | Should -Throw
        { Update-User -UserId 6 -Permission 0 -Confirm:$false } | Should -Throw
        { Update-User -UserId 6 -Permission 1 -Confirm:$false } | Should -Throw
        { Update-User -UserId 6 -Permission 15 -Confirm:$false } | Should -Throw
    }

    It 'Requires Permission to be at most 64' {
        { Update-User -UserId 6 -Permission 65 -Confirm:$false } | Should -Throw
        { Update-User -UserId 6 -Permission 128 -Confirm:$false } | Should -Throw
    }

    It 'Requires Email to be an email' {
        { Update-User -UserId 6 -Permission 32 -Email -1 -Confirm:$false } | Should -Throw
        { Update-User -UserId 6 -Permission 32 -Email 'a' -Confirm:$false } | Should -Throw
    }

    It 'Hits the correct endpoint - UserId' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/users/\d+$' }
        Update-User -UserId 6 -Permission 32 -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }
    It 'Hits the correct endpoint - UserUuid' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/users/[0-9a-fA-F\-]{36}$' }
        Update-User -UserUuid 'd64aa936-e63f-4227-a394-1699425f07e1' -Permission 32 -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Uses the correct method' {
        Mock Invoke-Method { } -ParameterFilter { $Method -eq 'Put' }
        Update-User -UserId 6 -Permission 32 -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the Name' {
        Mock Invoke-Method { } -ParameterFilter { $Body.name -eq 'First Last' }
        Update-User -UserId 6 -Permission 32 -Name 'First Last' -Confirm:$false 
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the Email' {
        Mock Invoke-Method { } -ParameterFilter { $Body.email -eq 'name@company.net' }
        Update-User -UserId 6 -Permission 32 -Email 'name@company.net' -Confirm:$false 
        Should -Invoke Invoke-Method -Exactly 1
    }
}
