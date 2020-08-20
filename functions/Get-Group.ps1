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
    $result = Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
    if ($result) {
        if ($result | Get-Member -Name groups) {
            $result | ForEach-Object groups
        } else {
            $result
        }
    }
}
