function dark()
{
   conemuc /GUIMACRO palette 3 "<Monokai>" > $null
}

function light()
{
   conemuc /GUIMACRO palette 3 "<Solarized Light>" > $null
}

function orange()
{
   conemuc /GUIMACRO palette 3 "Orange" > $null
}

function shane()
{
   conemuc /GUIMACRO palette 3 "<Standard VGA>" > $null
}

Export-ModuleMember -Alias * -Function *