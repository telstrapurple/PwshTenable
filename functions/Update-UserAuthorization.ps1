
function Update-UserAuthorization {
    <#
    .SYNOPSIS
        Updates user authorizations for accessing a Tenable.io instance. Use the endpoint to grant and revoke authorizations.
    .DESCRIPTION
        Updates user authorizations for accessing a Tenable.io instance. Use the endpoint to grant and revoke authorizations.
    .EXAMPLE
        PS /> Update-TenableUserAuthorization -UserUuid d64aa936-e63f-4227-a394-1699425f07e1

        Enables a user using their uuid.
    .EXAMPLE
        PS /> Update-TenableUserAuthorization -Context $context -UserUuid d64aa936-e63f-4227-a394-1699425f07e1

        Enables a list of all users using a connection context.
    .NOTES
        You cannot update authorizations for the current user.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # The UUID of the user.
        [Parameter(Mandatory, ParameterSetName = 'uuid')]
        [Guid]
        $UserUuid,

        # Indicates whether API access is authorized for the user.
        [Parameter(Mandatory)]
        [Boolean]
        $ApiPermitted,

        # Indicates whether user name and password login is authorized for the user.
        [Parameter(Mandatory)]
        [Boolean]
        $PasswordPermitted,

        # Indicates whether SSO with SAML is authorized for the user.
        [Parameter(Mandatory)]
        [Boolean]
        $SamlPermitted,

        # Tenable Connection Context from `Get-TenableConnection`
        [Parameter()]
        [PSTypeName('TenableContext')]
        [PSCustomObject]
        $Context = $null
    )

    $path = "/users/$UserUuid/authorizations"
    $body = @{
        api_permitted      = $ApiPermitted
        password_permitted = $PasswordPermitted
        saml_permitted     = $SamlPermitted
    }

    $null = Invoke-Method -Context $Context -Method 'Put' -Path $path -Body $body -Verbose:$VerbosePreference
}
