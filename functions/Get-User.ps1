
function Get-User {
    <#
    .SYNOPSIS
        Returns a list of users or a specified user.
    .DESCRIPTION
        Returns a list of users or a specified user.
    .EXAMPLE
        PS /> Get-TenableUser

        Gets a list of all users
    .EXAMPLE
        PS /> Get-TenableUser -UserId d64aa936-e63f-4227-a394-1699425f07e1

        Gets a user using their uuid.
    .EXAMPLE
        PS /> Get-TenableUser -UserId 6

        Gets a user using their id.
    .EXAMPLE
        PS /> Get-TenableUser -Context $context

        Gets a list of all users using a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # The UUID (`uuid`) or unique ID (`id`) of the user.
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]
        $UserId,

        # Tenable Connection Context from `Get-TenableConnection`
        [Parameter()]
        [PSTypeName('TenableContext')]
        [PSCustomObject]
        $Context = $null
    )

    if ($PSBoundParameters.ContainsKey('UserId')) {
        $path = "/users/$UserId"
    } else {
        $path = '/users'
    }

    Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
}
