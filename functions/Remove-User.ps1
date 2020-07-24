
function Remove-User {
    <#
    .SYNOPSIS
        Deletes a user
    .DESCRIPTION
        Deletes a user
    .EXAMPLE
        PS /> Remove-TenableUser -UserId d64aa936-e63f-4227-a394-1699425f07e1

        Deletes a user using their uuid.
    .EXAMPLE
        PS /> Remove-TenableUser -UserId 6

        Deletes a user using their id.
    .EXAMPLE
        PS /> Remove-TenableUser -Context $context -UserId 6

        Deletes a user using their id and a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        # The UUID (`uuid`) or unique ID (`id`) of the user.
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]
        $UserId,

        # Tenable Connection Context from `Get-TenableConnection`
        [Parameter()]
        [PSTypeName('TenableContext')]
        [PSCustomObject]
        $Context = $null
    )

    $path = "/users/$UserId"

    if ($PSCmdlet.ShouldProcess($UserId, 'Delete User')) {
        Invoke-Method -Context $Context -Method 'Delete' -Path $path -Verbose:$VerbosePreference
    }
}
