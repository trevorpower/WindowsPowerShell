Import-Module 'C:\tools\poshgit\dahlbyk-posh-git-*\profile.example.ps1'
Import-Module ConEmu
Import-Module -force PSProfile
Import-Module SublimeText

. "$PSScriptRoot\colors.ps1"
. "$PSScriptRoot\commands.ps1"

&{
  $console = $host.UI.RawUI
  $buffer = $console.BufferSize
  $buffer.Width = 130
  $buffer.Height = 2000
  $console.BufferSize = $buffer
}

&{
  $vs = "${env:ProgramFiles(x86)}\Microsoft Visual Studio 14.0\Common7\IDE"
  if (test-path($vs)) {
    $env:PATH += ";$vs"
  }

  $gitBin = "${env:ProgramFiles}\Git\bin\"
  if (test-path($gitBin)) {
    $env:PATH += ";$gitBin"
  }

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