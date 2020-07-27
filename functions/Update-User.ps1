function Update-User {
    <#
    .SYNOPSIS
        Updates an existing user account.
    .DESCRIPTION
        Updates an existing user account.
    .EXAMPLE
        PS /> Update-TenableUser -UserUuid d64aa936-e63f-4227-a394-1699425f07e1 -Permission 32

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

        # The user permissions as described in: https://developer.tenable.com/docs/permissions
        [Parameter(Mandatory)]
        [ValidateRange(16, 64)]
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

    switch ($PSCmdlet.ParameterSetName) {
        'uuid' {
            $path = "/users/$UserUuid"
        }
        'id' {
            $path = "/users/$UserId"
        }
    }

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

    if ($PSCmdlet.ShouldProcess($UserId, 'Update User')) {
        Invoke-Method -Context $Context -Method 'Put' -Path $path -Body $body -Verbose:$VerbosePreference
    }
}
