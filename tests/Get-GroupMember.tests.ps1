$IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

Describe 'Get-GroupMember' {
        
    BeforeAll {
        . $PSCommandPath.Replace('.tests.ps1','.ps1').Replace('tests', 'functions')

        function Invoke-Method ($Method = 'Get', $Path, $Body) { }
    }

    It 'Requires a GroupId to be supplied' -Skip:$IsInteractive {
        { Get-GroupMember } | Should -Throw
    }

    It 'Requires GroupId to be positive' {
        { Get-GroupMember -GroupId -1 } | Should -Throw
    }

    It 'Requires GroupId to be Int32' {
        { Get-GroupMember -GroupId 'a' } | Should -Throw
    }

    It 'Hits the correct endpoint' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/groups/\d+/users$' }
        Get-GroupMember -GroupId 8
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Uses the correct method' {
        Mock Invoke-Method { } -ParameterFilter { $null -eq $Method -or $Method -eq 'Get' }
        Get-GroupMember -GroupId 8
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the GroupId' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/8/' }
        Get-GroupMember -GroupId 8
        Should -Invoke Invoke-Method -Exactly 1
    }
}
