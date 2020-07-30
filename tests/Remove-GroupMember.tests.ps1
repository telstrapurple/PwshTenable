$IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

Describe 'Remove-GroupMember' {
        
    BeforeAll {
        . $PSCommandPath.Replace('.tests.ps1','.ps1').Replace('tests', 'functions')

        function Invoke-Method ($Method = 'Get', $Path, $Body) { }
    }

    It 'Requires a GroupId to be supplied' -Skip:$IsInteractive {
        { Remove-GroupMember -UserId 6 -Confirm:$false } | Should -Throw
    }

    It 'Requires GroupId to be positive' {
        { Remove-GroupMember -GroupId -1 -UserId 6 -Confirm:$false } | Should -Throw
    }

    It 'Requires GroupId to be Int32' {
        { Remove-GroupMember -GroupId 'a' -UserId 6 -Confirm:$false } | Should -Throw
    }

    It 'Requires a UserId to be supplied' -Skip:$IsInteractive {
        { Remove-GroupMember -GroupId 8 -Confirm:$false } | Should -Throw
    }

    It 'Requires UserId to be positive' {
        { Remove-GroupMember -GroupId 8 -UserId -1 -Confirm:$false } | Should -Throw
    }

    It 'Requires UserId to be Int32' {
        { Remove-GroupMember -GroupId 8 -UserId 'a' -Confirm:$false } | Should -Throw
    }

    It 'Hits the correct endpoint' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/groups/\d+/users/\d+$' }
        Remove-GroupMember -GroupId 8 -UserId 6 -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Uses the correct method' {
        Mock Invoke-Method { } -ParameterFilter { $Method -eq 'Delete' }
        Remove-GroupMember -GroupId 8 -UserId 6 -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the GroupId' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/8/' }
        Remove-GroupMember -GroupId 8 -UserId 6 -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the UserId' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/6$' }
        Remove-GroupMember -GroupId 8 -UserId 6 -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Does nothing when given -WhatIf' {
        Mock Invoke-Method { }
        Remove-GroupMember -GroupId 8 -UserId 6 -WhatIf
        Should -Invoke Invoke-Method -Exactly 0
    }
}
