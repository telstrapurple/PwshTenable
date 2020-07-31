$IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

Describe 'Remove-Group' {
        
    BeforeAll {
        . $PSCommandPath.Replace('.tests.ps1','.ps1').Replace('tests', 'functions')

        function Invoke-Method ($Method = 'Get', $Path, $Body) { }
    }

    It 'Requires a GroupId to be supplied' -Skip:$IsInteractive {
        { Remove-Group -Confirm:$false } | Should -Throw
    }

    It 'Requires GroupId to be positive' {
        { Remove-Group -GroupId -1 -Confirm:$false } | Should -Throw
    }

    It 'Requires GroupId to be Int32' {
        { Remove-Group -GroupId 'a' -Confirm:$false } | Should -Throw
    }

    It 'Hits the correct endpoint' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/groups/\d+' }
        Remove-Group -GroupId 8 -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Uses the correct method' {
        Mock Invoke-Method { } -ParameterFilter { $Method -eq 'Delete' }
        Remove-Group -GroupId 8 -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the GroupId' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/8$' }
        Remove-Group -GroupId 8 -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Does nothing when given -WhatIf' {
        Mock Invoke-Method { }
        Remove-Group -GroupId 8 -WhatIf
        Should -Invoke Invoke-Method -Exactly 0
    }
}
