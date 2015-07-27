&{

  write-host " PS $($PSVersionTable.PSVersion) " -foregroundcolor "Black" -backgroundcolor "DarkGreen" -nonewline

  write-host " " -nonewline

  $vs = "${env:ProgramFiles(x86)}\Microsoft Visual Studio 12.0\Common7\IDE"
  $found = test-path($vs)
  if ($found) {
    write-host " VS 2013 " -foregroundcolor "Black"  -backgroundcolor "DarkGreen" -nonewline
    $env:PATH += ";$vs"
  }
  else {
    write-host " VS n/a " -foregroundcolor "Black"  -backgroundcolor "DarkRed" -nonewline
  }

  write-host " " -nonewline
 
  if (Get-Command "nuget" -ErrorAction SilentlyContinue) { 
    write-host " nuget " -foregroundcolor "Black"  -backgroundcolor "DarkGreen" -nonewline
  }
  else {
    write-host " nuget " -foregroundcolor "Black"  -backgroundcolor "DarkRed" -nonewline      
  }

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

    $char = @{$true='#';$false='>'}[$isAdmin]

    return "$dir$char ";
  }
}

set-alias installutil $env:windir\Microsoft.NET\Framework64\v4.0.30319\InstallUtil