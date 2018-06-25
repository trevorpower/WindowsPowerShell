  $netBin = "${env:windir}\Microsoft.NET\Framework64\v4.0.30319"
  if (test-path($netBin)) {
    $env:PATH += ";$netBin"
  }