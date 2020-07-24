
function Invoke-Method {
    <#
    .SYNOPSIS
        Invokes a Tenable Api Method
    .DESCRIPTION
        Invokes a Tenable Api Method
    .EXAMPLE
        PS /> Invoke-TenableMethod -Path '/users'

        Makes a GET request to the /users endpoint.
    .EXAMPLE
        PS /> Invoke-TenableMethod -Method 'Delete' -Path '/users/6'

        Makes a DELETE request to the /users/{user_id} endpoint.
    .EXAMPLE
        PS /> Invoke-TenableMethod -Path '/users' -Retry $false

        Makes a GET request to the /users endpoint without automatic retry in case of api rate limiting or transient network issues.
    .EXAMPLE
        PS /> Invoke-TenableMethod -Method 'Update' -Path '/users/6' -Body @{ permissions = 64 }

        Makes a Update request to the /users/{user_id} endpoint to update the permissions level.
    .EXAMPLE
        PS /> Invoke-TenableMethod -Context $context -Path '/users'

        Makes a GET request to the /users endpoint using a connection context.
    .NOTES
        $Body is automatically converted to Json
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # Rest Method
        [Parameter()]
        [ValidateSet('Delete', 'Get', 'Post', 'Put')]
        [String]
        $Method = 'Get',

        # Path of the rest request. eg `/Account`
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Path,

        # Body of the Rest call
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]
        $Body,

        # Whether to retry when rate limited.
        [Parameter()]
        [Boolean]
        $Retry = $true,

        # Tenable Connection Context from `Get-TenableConnection`
        [Parameter()]
        [PSTypeName('TenableContext')]
        [PSCustomObject]
        $Context = $null
    )

    # Determine the context
    if ($null -eq $Context) {
        if (Test-Path Variable:\Script:Context) {
            $Context = $Script:Context
        } else {
            throw $Script:NotConnectedMessage
        }
    }

    $params = @{
        Method         = $Method
        SslProtocol    = 'Tls12'
        Verbose        = $VerbosePreference
        Headers        = @{
            'Accept'    = 'application/json'
            'x-apikeys' = 'accessKey={0};secretKey={1}' -f $Context.AccessKey.GetNetworkCredential().Password, $Context.SecretKey.GetNetworkCredential().Password
        }
    }

    if ($PSBoundParameters.ContainsKey('Body')) {
        $params.Body = $Body | ConvertTo-Json -Depth 10 -Compress
        $params.ContentType = 'application/json'
        $params.Body | Out-String | Write-Debug
    }

    $uri = 'https://cloud.tenable.com/' + $Path.TrimStart('/')

    $multiplier = 0.5
    while (-not [String]::IsNullOrEmpty($uri)) {
        try {
            $result = Invoke-RestMethod @params -Uri $uri
            $result
            $uri = $null

        } catch [Microsoft.PowerShell.Commands.HttpResponseException] {
            $errorRecord = $_
            $response = $errorRecord.Exception.Response

            if ($Retry -and $response.StatusCode -in @(429, 502, 503, 504)) {
                $response | Select-Object StatusCode, ReasonPhrase | ConvertTo-Json -Compress | Write-Warning

                $retryAfter = $response.Headers.RetryAfter ? $response.Headers.RetryAfter.Delta.TotalSeconds : 5

                $multiplier *= 2
                $jitter = Get-Random -Minimum 0.0 -Maximum 1.0
                $sleep = $retryAfter + $multiplier + $jitter

                if ($sleep -gt 30) {
                    Write-Warning -Message "Long sleep! $sleep"
                }
                $null = Start-Sleep -Seconds $sleep

            } else {
                throw $errorRecord
            }
        } catch {
            $errorRecord = $_
            throw $errorRecord
        }
    }
}
