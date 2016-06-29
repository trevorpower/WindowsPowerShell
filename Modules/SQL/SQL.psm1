function Restore-Database($name, $path) 
{
   SQLCMD.EXE -E -Q "RESTORE DATABASE [$name] FROM DISK='$path'"
}

function Backup-Database($name, $path)
{
   SQLCMD.EXE -E -Q "BACKUP DATABASE [$name] TO DISK='$path' "
}

function Remove-Database($name)
{
   SQLCMD.EXE -E -Q "alter database [$name] set single_user with rollback immediate"
   SQLCMD.EXE -E -Q "drop database [$name]"
}

Set-Alias resdb Restore-Database
Set-Alias bakdb Backup-Database
Set-Alias dropdb Remove-Database

Export-ModuleMember -Alias * -Function *
