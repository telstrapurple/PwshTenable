$IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

Describe 'New-Group' {
        
    BeforeAll {
        . $PSCommandPath.Replace('.tests.ps1','.ps1').Replace('tests', 'functions')

        function Invoke-Method ($Method = 'Get', $Path, $Body) { }
    }

    It 'Requires Name to be supplied' -Skip:$IsInteractive {
        { New-Group -Confirm:$false } | Should -Throw
    }

    It 'Hits the correct endpoint' {
        Mock Invoke-Method { } -ParameterFilter { $Path -match '/groups$' }
        New-Group -Name 'Application' -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Uses the correct method' {
        Mock Invoke-Method { } -ParameterFilter { $Method -eq 'Post' }
        New-Group -Name 'Application' -Confirm:$false
        Should -Invoke Invoke-Method -Exactly 1
    }

    It 'Passes on the Name' {
        Mock Invoke-Method { } -ParameterFilter { $Body.Name -eq 'Application' }
        New-Group -Name 'Application' -Confirm:$false 
        Should -Invoke Invoke-Method -Exactly 1
    }
}
