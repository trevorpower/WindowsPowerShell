function Get-CurrentBranch() {
    git rev-parse --abbrev-ref HEAD
}

Export-ModuleMember -Alias * -Function Get-CurrentBrach