function global:Pop-Directory(){
   Set-Location ..
}

function global:Reset-Directory(){
   Set-Location ~
}

function global:Find-Aliases($definition){
   Get-Alias -Definition *$definition*
}

function global:Stop-ProcessByName($name){
   Stop-Process -Name $name
}

function global:Stop-ProcessByName($name){
   Stop-Process -Name $name
}

function global:Connect-Machine($name){
   if (-Not $name) {
      Get-ChildItem ~/.rdp | %{ $_.BaseName }
   }
   else {
      mstsc (Get-Item "~/.rdp/$name.rdp").Fullname
   }
}

function global:Restart-Machine(){
   shutdown /r /t 00
}

function global:Set-LocationWebAppHome(){
    Try
    {
        pushd $env:WEB_APP_HOME
        gulp
    }
    Finally
    {
        popd
    }
}

Set-Alias ~ Reset-Directory
Set-Alias .. Pop-Directory
Set-Alias al Find-Aliases
Set-Alias cull Stop-ProcessByName
Set-Alias sync Sync-PSProfile
Set-Alias rdp Connect-Machine
Set-Alias restart Restart-Machine
Set-Alias kulp Set-LocationWebAppHome
