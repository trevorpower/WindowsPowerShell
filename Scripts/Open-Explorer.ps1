[CmdletBinding()]param (
    [Parameter(Position = 0)]
    $Location = '.'
)

explorer.exe $Location