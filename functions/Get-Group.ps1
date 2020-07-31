function Get-Group {
    <#
    .SYNOPSIS
        Returns the group list.
    .DESCRIPTION
        Returns the group list.
    .EXAMPLE
        PS /> Get-TenableGroup

        Returns the group list.
    .EXAMPLE
        PS /> Get-TenableGroup -Context $context

        Returns the group list using a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # Tenable Connection Context from `Get-TenableConnection`
        [Parameter()]
        [PSTypeName('TenableContext')]
        [PSCustomObject]
        $Context = $null
    )

    $path = '/groups'
    Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
}
