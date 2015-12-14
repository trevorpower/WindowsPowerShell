function Switch-WindowOnTop()
{
   conemuc /GUIMACRO SetOption("AlwaysOnTop", 2)
}

New-Alias front -Value Switch-WindowOnTop

Export-ModuleMember -Alias * -Function *