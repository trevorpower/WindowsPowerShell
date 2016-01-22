[CmdletBinding()]Param(
    [Parameter(Mandatory=$true)]
    [string]$definition

)

Get-Alias -Definition *$definition*