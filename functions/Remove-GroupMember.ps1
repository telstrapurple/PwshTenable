function Remove-GroupMember {
    <#
    .SYNOPSIS
        Removes a user from the group.
    .DESCRIPTION
        Removes a user from the group.
    .EXAMPLE
        PS /> Remove-TenableGroupMember -GroupId 8 -UserId 6

        Removes a user from a group.
    .EXAMPLE
        PS /> Remove-TenableGroupMember -Context $context -GroupId 8 -UserId 6

        Removes a user from a group using a connection context.
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

    if ($PSCmdlet.ShouldProcess("$UserId => $GroupId", 'Remove Group Member')) {
        Invoke-Method -Context $Context -Method 'Delete' -Path $path -Verbose:$VerbosePreference
    }
}
