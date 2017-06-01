function good($value) {
    write-host " $value " -foregroundcolor "Black"  -backgroundcolor "DarkGreen" -nonewline
}
function bad($value) {
    write-host " $value " -foregroundcolor "Black"  -backgroundcolor "DarkRed" -nonewline    
}
function sep() {
    write-host " " -nonewline
}
function printCommandStatus([System.Collections.ArrayList]$names) {
    Get-Command $names -CommandType Application -ErrorAction Silent |
    %{ $_.Name.Split(".")[0].ToLower() } |
    %{ $names.remove($_); sep; good $_ }
    $names | %{ sep; bad $_ }
}

function global:Show-TerminalStatus(){
    good "PS $($PSVersionTable.PSVersion)"
    printCommandStatus "tf", "git", "nuget", "npm", "choco", "conemuc", "msbuild", "subl", "sh", "nunit"
    write-host
}

function global:Edit-PSProfile() {
    subl (Get-Item "~\projects\ps-profile.sublime-project").Fullname
}

function global:Sync-PSProfile() {
   pushd $PSScriptRoot

   git pull
   git push

   popd

   . $PROFILE
}