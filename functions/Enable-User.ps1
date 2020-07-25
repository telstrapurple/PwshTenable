
function Enable-User {
    <#
    .SYNOPSIS
        Enables an existing user account.
    .DESCRIPTION
        Enables an existing user account.
    .EXAMPLE
        PS /> Enable-TenableUser -UserId 6

        Enables a user using their id.
    .EXAMPLE
        PS /> Enable-TenableUser -Context $context -UserId 6

        Enables a user using a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # The ID of the user.
        [Parameter(Mandatory, ParameterSetName = 'id')]
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
        enabled = $true
    }

    Invoke-Method -Context $Context -Method 'Put' -Path $path -Body $body -Verbose:$VerbosePreference
}
