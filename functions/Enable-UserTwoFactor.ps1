function Enable-UserTwoFactor {
    <#
    .SYNOPSIS
        Enables a user's two-factor authentication settings.
    .DESCRIPTION
        Enables a user's two-factor authentication settings.
    .EXAMPLE
        PS /> Enable-UserTwoFactor -UserId 6 -SmsPhone '+19998887777' -EmailEnabled $true

        Enables SMS two-factor authentication for a user but not backup email 2FA.
    .EXAMPLE
        PS /> Enable-UserTwoFactor -UserId 6 -SmsPhone '+19998887777' -EmailEnabled $false

        Enables SMS two-factor authentication for a user as well as backup email 2FA.
    .Notes
        SmsPhone Must begin with the + character and the country code.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # The ID of the user.
        [Parameter(Mandatory)]
        [ValidateRange(1, [Int32]::MaxValue)]
        [Int32]
        $UserId,

        # Specifies whether backup notification for two-factor authentication is enabled.
        [Parameter(Mandatory)]
        [Boolean]
        $EmailEnabled,

        # The phone number to use for two-factor authentication.
        [Parameter(Mandatory)]
        [ValidatePattern('^\+[0-9]+$')]
        [String]
        $SmsPhone,

        # Tenable Connection Context from `Get-TenableConnection`
        [Parameter()]
        [PSTypeName('TenableContext')]
        [PSCustomObject]
        $Context = $null
    )

    $path = "/users/$UserId/two-factor"
    $body = @{
        email_enabled = $EmailEnabled
        sms_enabled = $true
        sms_phone = $SmsPhone
    }

    Invoke-Method -Context $Context -Method 'Put' -Path $path -Body $body -Verbose:$VerbosePreference
}
