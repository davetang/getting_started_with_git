# README

Steps for testing `git rebase`.

1. Created a new branch called `rebase_demo` and made some commits:

```
ed308fc 2025-11-29 | Add README
ab45c5c 2025-11-29 | Update feature with more work [Dave Tang]
2c162f7 2025-11-29 | Add feature file [Dave Tang
```

2. Switched back to `main` and made one commit:

```
033b592 2025-11-29 | git rebase [Dave Tang]
```

3. Switched back to `rebase_demo` and run:

```console
git checkout rebase_demo
git rebase main
```

4. Switched back to `main` and merged:

```console
git checkout main
git merge rebase_demo
```

The commit log is now:

```
ed308fc 2025-11-29 | Add README (HEAD -> main, origin/main, origin/HEAD, rebase_demo) [Dave Tang]
ab45c5c 2025-11-29 | Update feature with more work [Dave Tang]
2c162f7 2025-11-29 | Add feature file [Dave Tang]
033b592 2025-11-29 | git rebase [Dave Tang]
```
