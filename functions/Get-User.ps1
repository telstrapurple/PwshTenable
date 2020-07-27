
function Get-User {
    <#
    .SYNOPSIS
        Returns a list of users or a specified user.
    .DESCRIPTION
        Returns a list of users or a specified user.
    .EXAMPLE
        PS /> Get-TenableUser

        Gets a list of all users
    .EXAMPLE
        PS /> Get-TenableUser -UserId d64aa936-e63f-4227-a394-1699425f07e1

        Gets a user using their uuid.
    .EXAMPLE
        PS /> Get-TenableUser -UserId 6

        Gets a user using their id.
    .EXAMPLE
        PS /> Get-TenableUser -Context $context

        Gets a list of all users using a connection context.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(DefaultParameterSetName = 'all')]
    Param (
        # The UUID of the user.
        [Parameter(Mandatory, ParameterSetName = 'uuid')]
        [Guid]
        $UserUuid,

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

    switch ($PSCmdlet.ParameterSetName) {
        'uuid' {
            $path = "/users/$UserUuid"
        }
        'id' {
            $path = "/users/$UserId"
        }
        default {
            $path = '/users'
        }
    }

    $result = Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
    if ($result) {
        if ($result | Get-Member -Name users) {
            $result | ForEach-Object users
        } else {
            $result
        }
    }
}
