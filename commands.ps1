function global:Pop-Directory(){
  Set-Location ..
}

function global:Reset-Directory(){
  Set-Location ~
}

function global:Find-Aliases($definition){
  Get-Alias -Definition *$definition*
}

Set-Alias ~ Reset-Directory
Set-Alias .. Pop-Directory
Set-Alias al Find-Aliases