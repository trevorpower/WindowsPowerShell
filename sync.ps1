function global:Sync-PSProfile() {
   pushd $PSScriptRoot

   git pull

   popd

   . $PROFILE
}