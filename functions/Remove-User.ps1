
function Remove-User {
    <#
    .SYNOPSIS
        Deletes a user
    .DESCRIPTION
        Deletes a user
    .EXAMPLE
        PS /> Remove-TenableUser -UserUuid d64aa936-e63f-4227-a394-1699425f07e1

        Deletes a user using their uuid.
    .EXAMPLE
        PS /> Remove-TenableUser -UserId 6

        Deletes a user using their id.
    .EXAMPLE
        PS /> Remove-TenableUser -Context $context -UserId 6

        Deletes a user using their id and a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess, ConfirmImpact = 'High', DefaultParameterSetName = 'uuid')]
    Param (
        # The UUID of the user.
        [Parameter(Mandatory, ParameterSetName = 'uuid')]
        [Guid]
        $UserUuid,

        # The ID of the user.
        [Parameter(Mandatory, ParameterSetName = 'id')]
        [ValidateRange(1, [Int32]::MaxValue)]
        [Int32]
        $UserId,

        # Tenable Connection Context from `Get-TenableConnection`
        [Parameter()]
        [PSTypeName('TenableContext')]
        [PSCustomObject]
        $Context = $null
    )

    switch ($PSCmdlet.ParameterSetName) {
        'uuid' {
            $path = "/users/$UserUuid"
        }
        'id' {
            $path = "/users/$UserId"
        }
    }

    if ($PSCmdlet.ShouldProcess($UserId, 'Delete User')) {
        Invoke-Method -Context $Context -Method 'Delete' -Path $path -Verbose:$VerbosePreference
    }
}
