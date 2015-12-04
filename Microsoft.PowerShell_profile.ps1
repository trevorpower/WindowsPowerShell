&{
  $vs = "${env:ProgramFiles(x86)}\Microsoft Visual Studio 12.0\Common7\IDE"
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
  printCommandStatus "tf", "git", "nuget", "npm", "choco", "conemuc", "msbuild"
  write-host

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

Import-Module C:\tools\poshgit\dahlbyk-posh-git-fadc4dd\posh-git

. "$PSScriptRoot\colors.ps1"
. "$PSScriptRoot\commands.ps1"