  $gitBin = "${env:ProgramFiles}\Git\bin\"
  if (test-path($gitBin)) {
    $env:PATH += ";$gitBin"
  }