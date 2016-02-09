function Clean-GitRepo() {
    git clean -df
    git checkout -- *
    git gc --prune=now
    git remote prune origin
    npm install
    gulp --production
}

Export-ModuleMember -Alias * -Function *