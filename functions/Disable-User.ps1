
function Disable-User {
    <#
    .SYNOPSIS
        Disables an existing user account.
    .DESCRIPTION
        Disables an existing user account.
    .EXAMPLE
        PS /> Disable-TenableUser -UserId 6

        Disables a user using their id.
    .EXAMPLE
        PS /> Disable-TenableUser -Context $context -UserId 6

        Disables a user using a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # The ID of the user.
        [Parameter(Mandatory)]
        [ValidateRange(1, [Int32]::MaxValue)]
        [Int32]
        $UserId,

        # Tenable Connection Context from `Get-TenableConnection`
        [Parameter()]
        [PSTypeName('TenableContext')]
        [PSCustomObject]
        $Context = $null
    )

    $path = "/users/$UserId/enabled"
    $body = @{
        enabled = $false
    }

    Invoke-Method -Context $Context -Method 'Put' -Path $path -Body $body -Verbose:$VerbosePreference
}
