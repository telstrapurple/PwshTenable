function Get-GroupMember {
    <#
    .SYNOPSIS
        Returns the group user list.
    .DESCRIPTION
        Returns the group user list.
    .EXAMPLE
        PS /> Get-TenableGroupMember -GroupId 8

        Returns the group user list.
    .EXAMPLE
        PS /> Get-TenableGroupMember -Context $context -GroupId 8

        Returns the group user list using a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # The unique ID of the group.
        [Parameter(Mandatory)]
        [ValidateRange(1, [Int32]::MaxValue)]
        [Int32]
        $GroupId,

        # Tenable Connection Context from `Get-TenableConnection`
        [Parameter()]
        [PSTypeName('TenableContext')]
        [PSCustomObject]
        $Context = $null
    )

    $path = "/groups/$GroupId/users"

    $result = Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
    if ($result) {
        if ($result | Get-Member -Name users) {
            $result | ForEach-Object users
        } else {
            $result
        }
    }
}
