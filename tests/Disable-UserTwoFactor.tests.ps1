$IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

Describe 'Disable-UserTwoFactor' {
        
    BeforeAll {
        . $PSCommandPath.Replace('.tests.ps1','.ps1').Replace('tests', 'functions')

        function Invoke-Method ($Method = 'Get', $Path, $Body) { }
    }

    It 'Requires a UserId to be supplied' -Skip:$IsInteractive {
        { Disable-UserTwoFactor } | Should -Throw
    }

    It 'Requires UserId to be positive' {
        { Disable-UserTwoFactor -UserId -1 } | Should -Throw
    }

    It 'Requires UserId to be Int32' {
        { Disable-UserTwoFactor -UserId 'a' } | Should -Throw
    }

    It 'Hits the correct endpoint' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/users/\d+/two-factor' }
        Disable-UserTwoFactor -UserId 6
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Uses the correct method' {
        Mock Invoke-Method { } -ParameterFilter { $Method -eq 'Put' }
        Disable-UserTwoFactor -UserId 6
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the UserId' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/6/' }
        Disable-UserTwoFactor -UserId 6
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Sets SmsEnabled' {
        Mock Invoke-Method { } -ParameterFilter { $Body.sms_enabled -eq $false }
        Disable-UserTwoFactor -UserId 6
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Sets EmailEnabled' {
        Mock Invoke-Method { } -ParameterFilter { $Body.email_enabled -eq $false }
        Disable-UserTwoFactor -UserId 6
        Should -Invoke Invoke-Method -Exactly 1
    }
}
