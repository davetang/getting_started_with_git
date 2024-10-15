# Forking

GitLab let's you fork your own repo unlike GitHub. Once a forked has been created, use the following to update the fork.

Add the original repository (called `upstream`) as a remote.

```console
git remote add upstream URL
```

Check that it is working.

```console
git remote -v
```

Fetch latest changes from `upstream`.

```console
git fetch upstream
```

Merge.

```console
git checkout main
git merge upstream/main
```

Resolve conflicts (if any) and push!

```console
git push origin main
```
