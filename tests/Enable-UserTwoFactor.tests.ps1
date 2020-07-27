$IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

Describe 'Enable-UserTwoFactor' {
        
    BeforeAll {
        . $PSCommandPath.Replace('.tests.ps1','.ps1').Replace('tests', 'functions')

        function Invoke-Method ($Method = 'Get', $Path, $Body) { }
    }

    It 'Requires a UserId to be supplied' -Skip:$IsInteractive {
        { Enable-UserTwoFactor -SmsPhone '+19998887777' -EmailEnabled $true } | Should -Throw
    }

    It 'Requires UserId to be positive' {
        { Enable-UserTwoFactor -UserId -1 -SmsPhone '+19998887777' -EmailEnabled $true } | Should -Throw
    }

    It 'Requires UserId to be Int32' {
        { Enable-UserTwoFactor -UserId 'a' -SmsPhone '+19998887777' -EmailEnabled $true } | Should -Throw
    }

    It 'Requires a SmsPhone to be supplied' -Skip:$IsInteractive {
        { Enable-UserTwoFactor -UserId 6 -EmailEnabled $true } | Should -Throw
    }

    It 'Requires SmsPhone to start with a +' {
        { Enable-UserTwoFactor -UserId 6 -SmsPhone '19998887777' -EmailEnabled $true } | Should -Throw
    }

    It 'Requires a EmailEnabled to be supplied' -Skip:$IsInteractive {
        { Enable-UserTwoFactor -UserId 6 -SmsPhone '+19998887777' } | Should -Throw
    }

    It 'Requires EmailEnabled to be a bool' {
        { Enable-UserTwoFactor -UserId 6 -SmsPhone '+19998887777' -EmailEnabled 'a' } | Should -Throw
    }

    It 'Hits the correct endpoint' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/users/\d+/two-factor' }
        Enable-UserTwoFactor -UserId 6 -SmsPhone '+19998887777' -EmailEnabled $true
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Uses the correct method' {
        Mock Invoke-Method { } -ParameterFilter { $Method -eq 'Put' }
        Enable-UserTwoFactor -UserId 6 -SmsPhone '+19998887777' -EmailEnabled $true
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the UserId' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/6/' }
        Enable-UserTwoFactor -UserId 6 -SmsPhone '+19998887777' -EmailEnabled $true
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Pass on the sms phone' {
        Mock Invoke-Method { } -ParameterFilter { $Body.sms_phone -eq '+19998887777' }
        Enable-UserTwoFactor -UserId 6 -SmsPhone '+19998887777' -EmailEnabled $true
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Pass on the email enabled - $true' {
        Mock Invoke-Method { } -ParameterFilter { $Body.email_enabled -eq $true }
        Enable-UserTwoFactor -UserId 6 -SmsPhone '+19998887777' -EmailEnabled $true
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Pass on the email enabled - $false' {
        Mock Invoke-Method { } -ParameterFilter { $Body.email_enabled -eq $false }
        Enable-UserTwoFactor -UserId 6 -SmsPhone '+19998887777' -EmailEnabled $false
        Should -Invoke Invoke-Method -Exactly 1
    }
}
