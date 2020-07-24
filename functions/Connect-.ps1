
function Connect- {
    <#
    .SYNOPSIS
        Connects to a Tenable instance.
    .DESCRIPTION
        Connects to a Tenable instance. Overriding any existing connection established previously with this function.
    .EXAMPLE
        PS /> $accessKey = Read-Host -Prompt 'Tenable Access Key' -AsSecureString
        PS /> $secretKey = Read-Host -Prompt 'Tenable Secret Key' -AsSecureString
        PS /> Connect-Tenable -AccessKey $accessKey -SecretKey $secretKey

        Connects to Tenable using an access key and a secret key read from the command line.
    #>
    [OutputType([Boolean])]
    [CmdletBinding()]
    Param (
        # Tenable API Access Key retrieved from https://cloud.tenable.com/app.html#/settings/my-account/api-keys
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [SecureString]
        $AccessKey,

        # Tenable API Secret Key retrieved from https://cloud.tenable.com/app.html#/settings/my-account/api-keys
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [SecureString]
        $SecretKey
    )

    $Script:Context = Get-Connection @PSBoundParameters

    $true
}
