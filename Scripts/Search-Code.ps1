[CmdletBinding()]
param (
    [Parameter(
        Mandatory = $true,
        Position = 0)]
    $Pattern,

    [switch]$SimpleMatch
)

$ext = @(Get-CodeExtensions | ForEach-Object{"*$_"})
Get-ChildItem . -Include $ext -Recurse | Select-String @PSBoundParameters 