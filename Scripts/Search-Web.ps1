param (
    [Parameter(Mandatory=$true)]
    $Search
)

Add-Type -AssemblyName System.Web

$encodedSearch = [System.Web.HttpUtility]::UrlEncode($Search)

Start-Process "https://google.com/#q=$encodedSearch"