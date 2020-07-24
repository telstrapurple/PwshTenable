function Update-User {
    <#
    .SYNOPSIS
        Updates an existing user account.
    .DESCRIPTION
        Updates an existing user account.
    .EXAMPLE
        PS /> Update-TenableUser -UserId d64aa936-e63f-4227-a394-1699425f07e1 -Permission 32

        Updates a user using their uuid.
    .EXAMPLE
        PS /> Update-TenableUser -UserId 6 -Permission 32

        Updates a user using their id.
    .EXAMPLE
        PS /> Update-TenableUser -UserId 6 -Permission 16 -Enabled $false

        Disables a user.
    .EXAMPLE
        PS /> Update-TenableUser -Context $context -UserId 6 -Permission 32

        Updates a user using their id and a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        # The UUID (`uuid`) or unique ID (`id`) of the user.
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]
        $UserId,

        # The user permissions as described in: https://developer.tenable.com/docs/permissions
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Int32]
        $Permission,

        # The name of the user (for example, first and last name).
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        # The email address of the user. A valid email address must be in the format, name@domain, where domain corresponds to a domain approved for your Tenable.io instance.
        [Parameter()]
        [ValidatePattern('@')]
        [String]
        $Email,

        # Specifies whether the user's account is enabled (`$true`) or disabled (`$false`).
        [Parameter()]
        [Boolean]
        $Enabled,

        # Tenable Connection Context from `Get-TenableConnection`
        [Parameter()]
        [PSTypeName('TenableContext')]
        [PSCustomObject]
        $Context = $null
    )

    $body = @{
        permissions = $Permission
    }

    if ($PSBoundParameters.ContainsKey('Name')) {
        $body['name'] = $Name
    }

    if ($PSBoundParameters.ContainsKey('Email')) {
        $body['email'] = $Email
    }

    if ($PSBoundParameters.ContainsKey('Enabled')) {
        $body['enabled'] = $Enabled
    }

    $path = "/users/$UserID"

    if ($PSCmdlet.ShouldProcess($UserId, 'Update User')) {
        Invoke-Method -Context $Context -Method 'Put' -Path $path -Body $body -Verbose:$VerbosePreference
    }
}
