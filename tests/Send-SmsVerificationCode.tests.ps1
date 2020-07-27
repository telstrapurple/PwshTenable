$IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

Describe 'Send-SmsVerificationCode' {
        
    BeforeAll {
        . $PSCommandPath.Replace('.tests.ps1','.ps1').Replace('tests', 'functions')

        function Invoke-Method ($Method = 'Get', $Path, $Body) { }
    }

    It 'Requires a UserId to be supplied' -Skip:$IsInteractive {
        { Send-SmsVerificationCode -SmsPhone '+19998887777' } | Should -Throw
    }

    It 'Requires UserId to be positive' {
        { Send-SmsVerificationCode -UserId -1 -SmsPhone '+19998887777' } | Should -Throw
    }

    It 'Requires UserId to be Int32' {
        { Send-SmsVerificationCode -UserId 'a' -SmsPhone '+19998887777' } | Should -Throw
    }

    It 'Requires a SmsPhone to be supplied' -Skip:$IsInteractive {
        { Send-SmsVerificationCode -UserId '6' } | Should -Throw
    }

    It 'Hits the correct endpoint' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/users/\d+/two-factor/send-verification' }
        Send-SmsVerificationCode -UserId 6 -SmsPhone '+19998887777'
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Uses the correct method' {
        Mock Invoke-Method { } -ParameterFilter { $Method -eq 'Post' }
        Send-SmsVerificationCode -UserId 6 -SmsPhone '+19998887777'
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the UserId' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/6/' }
        Send-SmsVerificationCode -UserId 6 -SmsPhone '+19998887777'
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Pass on the sms phone' {
        Mock Invoke-Method { } -ParameterFilter { $Body.sms_phone -eq '+19998887777' }
        Send-SmsVerificationCode -UserId 6 -SmsPhone '+19998887777'
        Should -Invoke Invoke-Method -Exactly 1
    }
}
