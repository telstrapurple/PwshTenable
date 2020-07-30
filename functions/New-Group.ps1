function New-Group {
    <#
    .SYNOPSIS
        Create a group.
    .DESCRIPTION
        Create a group.
    .EXAMPLE
        PS /> New-TenableGroup -Name 'Application'

        Create a group.
    .EXAMPLE
        PS /> New-TenableGroup -Context $context -Name 'Application'

        Create a group using a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        # The name of the group.
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        # Tenable Connection Context from `Get-TenableConnection`
        [Parameter()]
        [PSTypeName('TenableContext')]
        [PSCustomObject]
        $Context = $null
    )

    $path = '/groups'
    $body = @{
        name = $Name
    }

    if ($PSCmdlet.ShouldProcess($Name, 'Create Group')) {
        Invoke-Method -Context $Context -Method 'Post' -Path $path -Body $body -Verbose:$VerbosePreference
    }
}
