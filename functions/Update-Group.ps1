function Update-Group {
    <#
    .SYNOPSIS
        Edit a group.
    .DESCRIPTION
        Edit a group.
    .EXAMPLE
        PS /> Update-TenableGroup -GroupId 8 -Name 'Department'

        Renames a group.
    .EXAMPLE
        PS /> Update-TenableGroup -Context $context -GroupId 8 -Name 'Department'

        Renames a group using a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess, ConfirmImpact = 'High', DefaultParameterSetName = 'uuid')]
    Param (
        # The unique ID of the group.
        [Parameter(Mandatory)]
        [ValidateRange(1, [Int32]::MaxValue)]
        [Int32]
        $GroupId,

        # The name of the group.
        [Parameter(Mandatory)]
        [String]
        $Name,

        # Tenable Connection Context from `Get-TenableConnection`
        [Parameter()]
        [PSTypeName('TenableContext')]
        [PSCustomObject]
        $Context = $null
    )

    $path = "/groups/$GroupId"
    $body = @{
        name = $Name
    }

    if ($PSCmdlet.ShouldProcess($GroupId, 'Update Group Name')) {
        Invoke-Method -Context $Context -Method 'Put' -Path $path -Body $body -Verbose:$VerbosePreference
    }
}
