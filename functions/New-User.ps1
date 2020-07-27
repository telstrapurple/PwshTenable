function New-User {
    <#
    .SYNOPSIS
        Creates a new user.
    .DESCRIPTION
        Creates a new user.
    .EXAMPLE
        PS /> New-TenableUser -Username 'name@company.net'

        Creates a user.
    .EXAMPLE
        PS /> New-TenableUser -Username 'name@company.net' -Permission 64

        Creates a user with admin permissions.
    .EXAMPLE
        PS /> New-TenableUser -Context $context -Username 'name@company.net'

        Creates a user using their id and a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        # The login name for the user. A valid username must be in the format, `name@domain`, where `domain` corresponds to a domain approved for your Tenable.io instance.
        [Parameter(Mandatory)]
        [ValidatePattern('@')]
        [String]
        $Username,

        # The initial password for the user. Passwords must be at least 12 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character symbol.
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [SecureString]
        $Password,

        # The user permissions as described in: https://developer.tenable.com/docs/permissions
        [Parameter()]
        [ValidateRange(16, 64)]
        [Int32]
        $Permission = 32,

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

        # Tenable Connection Context from `Get-TenableConnection`
        [Parameter()]
        [PSTypeName('TenableContext')]
        [PSCustomObject]
        $Context = $null
    )

    if (-not $PSBoundParameters.ContainsKey('Password')) {
        if (Get-Command -Name openssl) {
            $plainTextPassword = openssl rand -base64 48
        } else {
            throw 'Automatic password generation requires OpenSSL. Please supply a password.'
        }
    } else {
        $plainTextPassword = [PSCredential]::new($Username, $Password).GetNetworkCredential().Password
    }

    $body = @{
        username = $Username
        password = $plainTextPassword
        permissions = $Permission
    }

    $plainTextPassword = $null

    if ($PSBoundParameters.ContainsKey('Name')) {
        $body['name'] = $Name
    }

    if ($PSBoundParameters.ContainsKey('Email')) {
        $body['email'] = $Email
    }

    $path = '/users'

    if ($PSCmdlet.ShouldProcess($Username, 'Create User')) {
        Invoke-Method -Context $Context -Method 'Post' -Path $path -Body $body -Verbose:$VerbosePreference
    }
}
