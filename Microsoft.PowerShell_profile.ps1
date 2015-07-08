function prompt()
{
  $principal = [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
  $isAdmin = $principal.IsInRole([Security.Principal.windowsBuiltInRole] "Administrator")

  $dir = (Get-Location | Split-Path -Leaf)
  $char = @{$true='#';$false='>'}[$isAdmin]

  return "$dir$char ";
}