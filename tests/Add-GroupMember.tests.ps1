$IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

Describe 'Add-GroupMember' {
        
    BeforeAll {
        . $PSCommandPath.Replace('.tests.ps1','.ps1').Replace('tests', 'functions')

        function Invoke-Method ($Method = 'Get', $Path, $Body) { }
    }

    It 'Requires a GroupId to be supplied' -Skip:$IsInteractive {
        { Add-GroupMember -UserId 6 -Confirm:$false } | Should -Throw
    }

    It 'Requires GroupId to be positive' {
        { Add-GroupMember -GroupId -1 -UserId 6 -Confirm:$false } | Should -Throw
    }

    It 'Requires GroupId to be Int32' {
        { Add-GroupMember -GroupId 'a' -UserId 6 -Confirm:$false } | Should -Throw
    }

    It 'Requires a UserId to be supplied' -Skip:$IsInteractive {
        { Add-GroupMember -GroupId 8 -Confirm:$false } | Should -Throw
    }

    It 'Requires UserId to be positive' {
        { Add-GroupMember -GroupId 8 -UserId -1 -Confirm:$false } | Should -Throw
    }

    It 'Requires UserId to be Int32' {
        { Add-GroupMember -GroupId 8 -UserId 'a' -Confirm:$false } | Should -Throw
    }

    It 'Hits the correct endpoint' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/groups/\d+/users/\d+$' }
        Add-GroupMember -GroupId 8 -UserId 6 -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Uses the correct method' {
        Mock Invoke-Method { } -ParameterFilter { $Method -eq 'Post' }
        Add-GroupMember -GroupId 8 -UserId 6 -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the GroupId' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/8/' }
        Add-GroupMember -GroupId 8 -UserId 6 -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the UserId' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/6$' }
        Add-GroupMember -GroupId 8 -UserId 6 -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Does nothing when given -WhatIf' {
        Mock Invoke-Method { }
        Add-GroupMember -GroupId 8 -UserId 6 -WhatIf
        Should -Invoke Invoke-Method -Exactly 0
    }
}
