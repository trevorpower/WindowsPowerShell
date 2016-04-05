function global:Sync-PSProfile() {
   pushd $PSScriptRoot

   git pull
   git push

   popd

   . $PROFILE
}