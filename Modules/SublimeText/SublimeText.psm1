$subl = "${env:ProgramFiles}\Sublime Text 3\"

if (Test-Path $subl) {
   $env:PATH += ";$subl"
}

