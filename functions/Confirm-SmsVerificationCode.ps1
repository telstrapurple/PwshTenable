
function Confirm-SMSVerificationCode {
    <#
    .SYNOPSIS
        Validate the verification code sent to a phone number.
    .DESCRIPTION
        Validate the verification code sent to a phone number. If this request is successful, it enables two-factor authentication for the specified user.
    .EXAMPLE
        PS /> Confirm-SMSVerificationCode -UserId 6 -VerificationCode '235024'

        Validate the verification code sent to a phone number.
    .EXAMPLE
        PS /> Confirm-SMSVerificationCode -Context $context -UserId 6 -VerificationCode '235024'

        Validate the verification code sent to a phone number using a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # The ID of the user.
        [Parameter(Mandatory)]
        [ValidateRange(1, [Int32]::MaxValue)]
        [Int32]
        $UserId,

        # The verification code sent in the send-verification request.
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]
        $VerificationCode,

        # Tenable Connection Context from `Get-TenableConnection`
        [Parameter()]
        [PSTypeName('TenableContext')]
        [PSCustomObject]
        $Context = $null
    )

    $path = "/users/$UserId/two-factor/verify-code"
    $body = @{
        verification_code = $VerificationCode
    }

    Invoke-Method -Context $Context -Method 'Post' -Path $path -Body $body -Verbose:$VerbosePreference
}
