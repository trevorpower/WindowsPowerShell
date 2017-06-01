Import-Module 'C:\tools\poshgit\dahlbyk-posh-git-*\profile.example.ps1'
Import-Module ConEmu
Import-Module -force PSProfile
Import-Module SublimeText
Import-Module MyGit

. "$PSScriptRoot\colors.ps1"
. "$PSScriptRoot\commands.ps1"

$nunitBin = "${env:ProgramFiles(x86)}\Nunit 2.6.4\bin\"
if (test-path($nunitBin)) {
  $env:PATH += ";$nunitBin"
}

&{
  $console = $host.UI.RawUI
  $buffer = $console.BufferSize
  $buffer.Width = 130
  $buffer.Height = 2000
  $console.BufferSize = $buffer
}

$MaximumHistoryCount = 200

&{
  $vs = "${env:ProgramFiles(x86)}\Microsoft Visual Studio 14.0\Common7\IDE"
  if (test-path($vs)) {
    $env:PATH += ";$vs"
  }

  function good($value) {
    write-host " $value " -foregroundcolor "Black"  -backgroundcolor "DarkGreen" -nonewline
  }
  function bad($value) {
    write-host " $value " -foregroundcolor "Black"  -backgroundcolor "DarkRed" -nonewline    
  }
  function sep() {
    write-host " " -nonewline
  }
  function printCommandStatus([System.Collections.ArrayList]$names) {
    Get-Command $names -CommandType Application -ErrorAction Silent |
    %{ $_.Name.Split(".")[0].ToLower() } |
    %{ $names.remove($_); sep; good $_ }
    $names | %{ sep; bad $_ }
  }
  good "PS $($PSVersionTable.PSVersion)"
  printCommandStatus "tf", "git", "nuget", "npm", "choco", "conemuc", "msbuild", "subl", "sh", "nunit"
  Write-Host

  function global:prompt()
  {
    $principal = [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
    $isAdmin = $principal.IsInRole([Security.Principal.windowsBuiltInRole] "Administrator")
    $location = Get-Location
    if ($location.Path -eq $env:HOMEDRIVE + $env:HOMEPATH) {
      $dir = '~'
    }
    else {
      $dir = Split-Path $location -Leaf
    }
    $branch = ''
    $branchSeperator = ''
    $gitRef = git symbolic-ref HEAD
    if($gitRef -ne $NULL) {
      $branchSeperator = ":"
      $branch = $gitRef.substring($gitRef.LastIndexOf("/") + 1)
    }
    $char = @{$true='#';$false='>'}[$isAdmin]
    Write-Host $dir -nonewline -foregroundcolor Gray
    Write-Host $branchSeperator -nonewline
    Write-Host $branch -nonewline  -foregroundcolor DarkYellow
    Write-Host $char -nonewline
    " "
  }
}

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
