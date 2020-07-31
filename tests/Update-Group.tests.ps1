$IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

Describe 'Update-Group' {
        
    BeforeAll {
        . $PSCommandPath.Replace('.tests.ps1','.ps1').Replace('tests', 'functions')

        function Invoke-Method ($Method = 'Get', $Path, $Body) { }
    }

    It 'Requires a GroupId to be supplied' -Skip:$IsInteractive {
        { Update-Group -Name 'Department' -Confirm:$false } | Should -Throw
    }

    It 'Requires GroupId to be positive' {
        { Update-Group -GroupId -1 -Name 'Department' -Confirm:$false } | Should -Throw
    }

    It 'Requires GroupId to be Int32' {
        { Update-Group -GroupId 'a' -Name 'Department' -Confirm:$false } | Should -Throw
    }

    It 'Requires a Name to be supplied' -Skip:$IsInteractive {
        { Update-Group -GroupId 8 -Confirm:$false } | Should -Throw
    }

    It 'Hits the correct endpoint' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/groups/\d+' }
        Update-Group -GroupId 8 -Name 'Department' -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Uses the correct method' {
        Mock Invoke-Method { } -ParameterFilter { $Method -eq 'Put' }
        Update-Group -GroupId 8 -Name 'Department' -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the GroupId' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/8$' }
        Update-Group -GroupId 8 -Name 'Department' -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the Name' {
        Mock Invoke-Method { } -ParameterFilter { $Body.Name -eq 'Departmnent' }
        Update-Group -GroupId 8 -Name 'Departmnent' -Confirm:$false 
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Does nothing when given -WhatIf' {
        Mock Invoke-Method { }
        Update-Group -GroupId 8 -Name 'Departmnent' -WhatIf
        Should -Invoke Invoke-Method -Exactly 0
    }
}
