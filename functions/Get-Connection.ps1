
function Get-Connection {
    <#
    .SYNOPSIS
        Returns a Tenable connection context
    .DESCRIPTION
        Returns an object describing a connection to Tenable
    .EXAMPLE
        PS /> $accessKey = Read-Host -Prompt 'Tenable Access Key' -AsSecureString
        PS /> $secretKey = Read-Host -Prompt 'Tenable Secret Key' -AsSecureString
        PS /> $context = Get-TenableConnection -AccessKey $accessKey -SecretKey $secretKey

        Sets $context to a connection context using an access key and a secret key read from the command line.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
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

    $context = [PSCustomObject]@{
        AccessKey = [PSCredential]::new('AccessKey', $AccessKey)
        SecretKey = [PSCredential]::new('SecretKey', $SecretKey)
    }

    $context | Add-Member -TypeName 'TenableContext'
    $context
}
