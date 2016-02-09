function Enable-AutoCompletion() {
    Invoke-Expression ((gulp --completion=powershell) -join [System.Environment]::NewLine)
}

Enable-AutoCompletion

Export-ModuleMember -Alias * -Function *
