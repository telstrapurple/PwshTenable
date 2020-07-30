function Add-GroupMember {
    <#
    .SYNOPSIS
        Add a user to the group.
    .DESCRIPTION
        Add a user to the group.
    .EXAMPLE
        PS /> Add-TenableGroupMember -GroupId 8 -UserId 6

        Add a user to the group.
    .EXAMPLE
        PS /> Add-TenableGroupMember -Context $context -GroupId 8 -UserId 6

        Add a user to the group using a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        # The unique ID of the group.
        [Parameter(Mandatory)]
        [ValidateRange(1, [Int32]::MaxValue)]
        [Int32]
        $GroupId,

        # The unique ID of the user.
        [Parameter(Mandatory)]
        [ValidateRange(1, [Int32]::MaxValue)]
        [Int32]
        $UserId,

        # Tenable Connection Context from `Get-TenableConnection`
        [Parameter()]
        [PSTypeName('TenableContext')]
        [PSCustomObject]
        $Context = $null
    )

    $path = "/groups/$GroupId/users/$UserId"

    if ($PSCmdlet.ShouldProcess("$UserId => $GroupId", 'Add Group Member')) {
        Invoke-Method -Context $Context -Method 'Post' -Path $path -Verbose:$VerbosePreference
    }
}
