# Git Cheatsheet

Essential commands.

## Initial Setup

| Command                                                   | Description                     |
|-----------------------------------------------------------|---------------------------------|
| `git config --global user.name "Your Name"`               | Set global user name            |
| `git config --global user.email "your.email@example.com"` | Set global user email           |
| `git config --list`                                       | View all configuration settings |

## Creating & Cloning Repositories

| Command                       | Description                     |
|-------------------------------|---------------------------------|
| `git init`                    | Initialize a new Git repository |
| `git clone <url>`             | Clone an existing repository    |
| `git clone <url> <directory>` | Clone into a specific directory |

## Basic Workflow

| Command                    | Description                      |
|----------------------------|----------------------------------|
| `git status`               | Show status of working directory |
| `git add <file>`           | Stage a specific file            |
| `git add .`                | Stage all changes                |
| `git commit -m "message"`  | Commit staged changes            |
| `git push origin <branch>` | Push commits to remote           |
| `git pull origin <branch>` | Fetch and merge remote changes   |

## Branching

| Command | Description |
|---------|-------------|
| `git branch` | List local branches |
| `git branch -a` | List all branches (local + remote) |
| `git branch <branch-name>` | Create a new branch |
| `git checkout <branch-name>` | Switch to a branch |
| `git checkout -b <branch-name>` | Create and switch to new branch |
| `git branch -d <branch-name>` | Delete a branch |
| `git merge <branch-name>` | Merge branch into current branch |

## Viewing History

| Command                            | Description                  |
|------------------------------------|------------------------------|
| `git log`                          | Show commit history          |
| `git log --oneline`                | Compact commit history       |
| `git log --graph --all --decorate` | Visual branch history        |
| `git log -p`                       | Show changes in each commit  |
| `git diff`                         | Show unstaged changes        |
| `git diff --staged`                | Show staged changes          |
| `git show <commit>`                | Show specific commit details |

## Undoing Changes

| Command | Description |
|---------|-------------|
| `git restore <file>` | Discard changes in working directory |
| `git restore --staged <file>` | Unstage a file |
| `git revert <commit>` | Create new commit that undoes changes |
| `git reset --soft HEAD~1` | Undo last commit (keep changes staged) |
| `git reset --mixed HEAD~1` | Undo last commit (keep changes unstaged) |
| `git reset --hard HEAD~1` | Undo last commit (discard changes) |

## Stashing

| Command           | Description                 |
|-------------------|-----------------------------|
| `git stash`       | Stash current changes       |
| `git stash list`  | List all stashes            |
| `git stash pop`   | Apply and remove last stash |
| `git stash apply` | Apply last stash (keep it)  |
| `git stash drop`  | Delete a stash              |

## Remote Repositories

| Command | Description |
|---------|-------------|
| `git remote -v` | Show remote repositories |
| `git remote add <n> <url>` | Add a new remote |
| `git remote remove <n>` | Remove a remote |
| `git fetch origin` | Download objects from remote |
| `git push origin <branch>` | Push branch to remote |
| `git pull origin <branch>` | Fetch and merge from remote |

## Tags

| Command                              | Description              |
|--------------------------------------|--------------------------|
| `git tag <tag-name>`                 | Create a lightweight tag |
| `git tag -a <tag-name> -m "message"` | Create an annotated tag  |
| `git tag -l`                         | List all tags            |
| `git push origin <tag-name>`         | Push tag to remote       |
| `git push origin --tags`             | Push all tags            |

## Advanced Commands

| Command                    | Description                              |
|----------------------------|------------------------------------------|
| `git rebase <branch>`      | Reapply commits on top of another branch |
| `git cherry-pick <commit>` | Apply specific commit to current branch  |
| `git bisect start`         | Binary search for problematic commit     |
| `git reflog`               | Show reference logs                      |
| `git clean -fd`            | Remove untracked files and directories   |
| `git blame <file>`         | Show who changed each line               |

## Tips & Best Practices

* Write meaningful commit messages that describe *what* and *why*, not just *what*
* Commit often with logical, atomic changes
* Pull before pushing to avoid conflicts
* Use branches for features and bug fixes
* Never force push to shared branches unless you know what you're doing
* Review your changes before committing with `git diff`
