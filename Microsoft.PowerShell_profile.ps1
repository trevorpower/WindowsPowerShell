&{
  $vs = "${env:ProgramFiles(x86)}\Microsoft Visual Studio 12.0\Common7\IDE"
  $found = test-path($vs)
  if ($found) {
    write-host "Visual Studio Available"
    $env:PATH += ";$vs"
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

    $char = @{$true='#';$false='>'}[$isAdmin]

    return "$dir$char ";
  }
}

