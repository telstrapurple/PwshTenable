function Remove-Group {
    <#
    .SYNOPSIS
        Delete a group.
    .DESCRIPTION
        Delete a group.
    .EXAMPLE
        PS /> Remove-TenableGroup -GroupId 8

        Delete a group.
    .EXAMPLE
        PS /> Remove-TenableGroup -Context $context -GroupId 8

        Delete a group using a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        # The unique ID of the group.
        [Parameter(Mandatory, ParameterSetName = 'id')]
        [ValidateRange(1, [Int32]::MaxValue)]
        [Int32]
        $GroupId,

        # Tenable Connection Context from `Get-TenableConnection`
        [Parameter()]
        [PSTypeName('TenableContext')]
        [PSCustomObject]
        $Context = $null
    )

    $path = "/groups/$GroupId"

    if ($PSCmdlet.ShouldProcess($GroupId, 'Delete Group')) {
        Invoke-Method -Context $Context -Method 'Delete' -Path $path -Verbose:$VerbosePreference
    }
}
