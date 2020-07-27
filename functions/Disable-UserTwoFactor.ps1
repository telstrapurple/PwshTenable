function Disable-UserTwoFactor {
    <#
    .SYNOPSIS
        Disables a user's two-factor authentication settings.
    .DESCRIPTION
        Disables a user's two-factor authentication settings.
    .EXAMPLE
        PS /> Disable-UserTwoFactor -UserId 6

        Disables two-factor authentication for a user.
    .EXAMPLE
        PS /> Disable-UserTwoFactor -Context $context -UserId 6

        Disables two-factor authentication for a user using a connection context.
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

    $path = "/users/$UserId/two-factor"
    $body = @{
        email_enabled = $false
        sms_enabled   = $false
    }

    Invoke-Method -Context $Context -Method 'Put' -Path $path -Body $body -Verbose:$VerbosePreference
}
