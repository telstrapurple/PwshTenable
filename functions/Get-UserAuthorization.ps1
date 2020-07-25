
function Get-UserAuthorization {
    <#
    .SYNOPSIS
        Returns user authorizations for accessing a Tenable.io instance.
    .DESCRIPTION
        Returns user authorizations for accessing a Tenable.io instance. Access methods include user name and password, single sign-on (SSO) with SAML, and API.
    .EXAMPLE
        PS /> Get-TenableUserAuthorization -UserUuid d64aa936-e63f-4227-a394-1699425f07e1

        Returns user authorizations using their uuid.
    .EXAMPLE
        PS /> Get-TenableUserAuthorization -Context $context -UserUuid d64aa936-e63f-4227-a394-1699425f07e1

        Returns user authorizations using a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # The UUID of the user.
        [Parameter(Mandatory)]
        [Guid]
        $UserUuid,

        # Tenable Connection Context from `Get-TenableConnection`
        [Parameter()]
        [PSTypeName('TenableContext')]
        [PSCustomObject]
        $Context = $null
    )

    $path = "/users/$UserUuid/authorizations"

    Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
}
