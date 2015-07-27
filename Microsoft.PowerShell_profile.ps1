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

  printCommandStatus "tf", "git", "nuget", "npm", "choco" 

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