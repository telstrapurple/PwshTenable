$IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

Describe 'Confirm-SmsVerificationCode' {
        
    BeforeAll {
        . $PSCommandPath.Replace('.tests.ps1','.ps1').Replace('tests', 'functions')

        function Invoke-Method ($Method = 'Get', $Path, $Body) { }
    }

    It 'Requires a UserId to be supplied' -Skip:$IsInteractive {
        { Confirm-SmsVerificationCode -VerificationCode '123456'} | Should -Throw
    }

    It 'Requires UserId to be positive' {
        { Confirm-SmsVerificationCode -UserId -1 -VerificationCode '123456'} | Should -Throw
    }

    It 'Requires UserId to be Int32' {
        { Confirm-SmsVerificationCode -UserId 'a' -VerificationCode '123456'} | Should -Throw
    }

    It 'Requires a VerificationCode to be supplied' -Skip:$IsInteractive {
        { Confirm-SmsVerificationCode -UserId 6 } | Should -Throw
    }

    It 'Hits the correct endpoint' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/users/\d+/two-factor/verify-code' }
        Confirm-SmsVerificationCode -UserId 6 -VerificationCode '123456'
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Uses the correct method' {
        Mock Invoke-Method { } -ParameterFilter { $Method -eq 'Post' }
        Confirm-SmsVerificationCode -UserId 6 -VerificationCode '123456'
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the UserId' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/6/' }
        Confirm-SmsVerificationCode -UserId 6 -VerificationCode '123456'
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Pass on the verification code' {
        Mock Invoke-Method { } -ParameterFilter { $Body.verification_code -eq '123456' }
        Confirm-SmsVerificationCode -UserId 6 -VerificationCode '123456'
        Should -Invoke Invoke-Method -Exactly 1
    }
}
