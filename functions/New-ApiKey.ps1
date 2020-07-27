
function New-ApiKey {
    <#
    .SYNOPSIS
        Generates the API keys for a user.
    .DESCRIPTION
        Generates the API keys for a user.
    .EXAMPLE
        PS /> New-ApiKey -UserId 6

        Generates the API keys for a user using their id.
    .EXAMPLE
        PS /> New-ApiKey -Context $context -UserId 6

        Generates the API keys for a user using a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
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

    $path = "/users/$UserId/keys"

    if ($PSCmdlet.ShouldProcess($UserId, 'Generate Api Keys')) {
        Invoke-Method -Context $Context -Method 'Put' -Path $path -Verbose:$VerbosePreference
    }
}
