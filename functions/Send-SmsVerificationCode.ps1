
function Send-SMSVerificationCode {
    <#
    .SYNOPSIS
        Sends a one-time verification code to the user's phone number to start the process of enabling two-factor authentication.
    .DESCRIPTION
        Sends a one-time verification code to the user's phone number to start the process of enabling two-factor authentication.
    .EXAMPLE
        PS /> Send-SMSVerificationCode -UserId 6 -SmsPhone '+19998887777'

        Sends a one-time verification code to the user.
    .EXAMPLE
        PS /> Send-SMSVerificationCode -Context $context -UserId 6 -SmsPhone '+19998887777'

        Sends a one-time verification code to the user using a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # The ID of the user.
        [Parameter(Mandatory)]
        [ValidateRange(1, [Int32]::MaxValue)]
        [Int32]
        $UserId,

        # The phone number where Tenable.io sends the one-time verification code. Must begin with the + character and the country code.
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

    $path = "/users/$UserId/two-factor/send-verification"
    $body = @{
        sms_phone = $SmsPhone
    }

    Invoke-Method -Context $Context -Method 'Post' -Path $path -Body $body -Verbose:$VerbosePreference
}
