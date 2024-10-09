## Table of Contents

- [Introduction](#introduction)
  - [Getting started](#getting-started)
  - [The Three Trees](#the-three-trees)
  - [Git checkout](#git-checkout)
  - [Change HTTPS to SSH](#change-https-to-ssh)
  - [Branches](#branches)
    - [Branching example](#branching-example)
    - [Renaming a branch](#renaming-a-branch)
    - [Default git init branch](#default-git-init-branch)
    - [HEAD](#head)
  - [Tagging](#tagging)
  - [Remotes](#remotes)
  - [Useful commands](#useful-commands)
    - [Show history of a file](#show-history-of-a-file)
    - [List all tracked files](#list-all-tracked-files)
    - [List all files that were tracked](#list-all-files-that-were-tracked)
  - [Undoing things](#undoing-things)
    - [Git reset](#git-reset)
    - [Git clean](#git-clean)
    - [Git revert](#git-revert)
  - [Submodules](#submodules)
- [GitHub](#github)
  - [GitHub CLI](#github-cli)
  - [GitHub Actions](#github-actions)
    - [Encrypted secrets](#encrypted-secrets)
    - [Safe directory](#safe-directory)
- [Aliases](#aliases)
- [Terminology](#terminology)
  - [Downstream and upstream](#downstream-and-upstream)
- [Useful links](#useful-links)

# Introduction

[Git](https://git-scm.com/) is an open source distributed version control system. [GitHub](https://github.com/) is an online repository where you can store your projects that use Git for its version controlling. There are many advantages to using version control and it is not too difficult to start using Git and GitHub. Furthermore, GitHub isn't just for storing code! I use it a lot just to store my study notes, which I like to share just in case they are useful to others.

You can clone this repository and make your own additional notes to this document (written in [Markdown](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)).

```bash
git clone https://github.com/davetang/getting_started_with_git.git
```

## Getting started

First thing is to [install Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) if you haven't already. Once installed, configure your name and email globally.

```console
git config --global user.name "Dave Tang"
git config --global user.email "davetingpongtang@gmail.com"
```

Check your user name and email.

```console
git config user.name
git config user.email
```

If you want a specific user name and email for a repository, `cd` into the repo and leave out `--global`.

```console
git config user.name "Dave Tang"
git config user.email "me@davetang.org"
```

You can use Git to version control any directory on your system. Simply navigate to the directory and use `git init`.

```bash
cd my_project
git init
```

A new directory called `.git` will be created inside the `my_project` directory and this is where Git stores the metadata and object database for your project; the working directory is a single checkout of one version of the project. If I take a look inside the `.git` directory for this repository, I can see the metadata and objects folder.

```bash
ls -1 .git
HEAD
config
description
hooks
index
info
logs
objects
packed-refs
refs
```

When you clone a repository from one computer, the directory where you initialised Git by running `git init` gets copied along with the `.git` directory.

You use Git to keep track of files and in Git, there are **three main stages** that a file can reside in:

1. Committed - means that the data is safely stored in your local database
2. Modified - means that you have changed the file but have not committed it to your database yet
3. Staged - means that you have marked a modified file in its current version to go into your next commit snapshot

The basic Git workflow goes something like this:

1. You modify a file in your working directory
2. You stage the file, adding a snapshot of it, to your staging area
3. You perform a commit, which takes the file as they are in the staging area and stores that snapshot permanently to your Git directory

Let's create a new file called `hello.txt`, which simply contains the string "hello".

```bash
echo hello > hello.txt
```

If we run `git status`, a command you will use a lot, we can see what stage the file is in.

```bash
git status
On branch master
Your branch is up to date with 'origin/master'.

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        hello.txt

nothing added to commit but untracked files present (use "git add" to track)
```

We can see that the file is untracked; we use [git add](https://git-scm.com/docs/git-add) to stage the file.

```bash
git add hello.txt 
```

Now we commit the file using [git commit](https://git-scm.com/docs/git-commit); it is good practice to add a message to your commit to help you keep track of all your commits.

```bash
git commit -m "My first commit!"
```

If we want to share our project with others, we can **push** our local repository to GitHub. You will need a GitHub account and once you have created an account and logged in, you will need to create a new online repository. Replace `davetang` with your own GitHub account and replace `blah` with the name you gave your repository.

```bash
# we are adding a new remote called "origin", which is GitHub
git remote add origin https://github.com/davetang/blah.git

# we are pushing the "master" branch of our local repository to remote
git push -u origin master
```

## The Three Trees

A nice illustration of the The Three Trees is provided in the [Git Tools -
Reset Demystified](https://git-scm.com/book/en/v2/Git-Tools-Reset-Demystified)
article, which is what the following notes are based on.

Git can be thought of as a content manager of three different trees, where in
this context, tree means a collection of files and not the tree data structure.
These three trees are related to the three basic Git workflow described above,
and illustrate how snapshots are recorded in successively better states.

![reset_workflow](img/reset-workflow.png)

The Working Directory contains the files that you edit and work with. When `git
add` is run, the files are staged and added to the Index. `git commit` takes
the contents of the Index, saves it as a permanent snapshot, creates a commit
object that points to that snapshot, and updates the branch to point to that
commit.

The Three Trees are useful for understanding [git reset](#git-reset).

## Git checkout

A checkout is an operation that moves the [HEAD](#head) ref pointer to a
specified commit. The `git checkout` command can be used in a commit or file
level scope. A file level checkout will change the file's contents to those of
the specified commit.

## Change HTTPS to SSH

For repositories that used HTTPS, change `url` under `[remote "origin"]` in your `.git/config` file from

    url = https://github.com/davetang/learning_docker.git

to

    url = git@github.com:davetang/learning_docker.git

Basically, substitute `https://` to `git@` and `github.com/` to `github.com:`.

Next add your SSH key.

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/your_key

# test your key
ssh -T git@github.com
```

You can add the following to `~/.ssh/config` to avoid running the steps above.

```
Host github.com
 HostName github.com
 User git
 IdentityFile ~/.ssh/your_key
```

Use the same SSH command to check if everything is working.

```bash
ssh -T git@github.com
```

## Branches

We pushed the "master" branch In the push command above. You can think of a branch as a tree branch, where you fork out from a common point. Branching is especially useful if you are working with others on the same repository and don't want to commit the changes to the main (master) branch since you are still testing your code. Once you are comfortable with your code, you can merge your branch with the master branch.

```bash
git checkout -b new_branch
Switched to a new branch 'new_branch'

# check which branch you are on
git branch
  master
* new_branch
```

You can read more about branching [here](https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging).

### Branching example

We want to work on the script `now.sh` but we are afraid that we may make changes that cause the script to malfunction or not execute as intended. We can create a new branch to test our changes. Some [guidelines](https://github.com/agis/git-style-guide#branches) on naming branches include:

1. Using short and descriptive names
2. Use GitHub issue numbers
3. Delete the branch after merging

```bash
#     -b <branch>           create and checkout a new branch
git checkout -b now_add_echo
Switched to a new branch 'now_add_echo'

git branch
  main
* now_add_echo
  test_gh_actions
```

Add new code.

```bash
#!/usr/bin/env bash

set -euo pipefail

now(){
   date '+%Y/%m/%d %H:%M:%S'
}

# seconds to sleep
s=2

>&2 printf "[ %s %s ] Start\n" $(now)
>&2 echo Sleeping for ${s} seconds
sleep ${s}
>&2 printf "[ %s %s ] End\n" $(now)

exit 0
```

Add and commit to `now_add_echo`.

```bash
git add now.sh
git commit -m 'echo sleep time'
```

If we switch back to the `main` branch, we will see the original `now.sh` script.

```bash
git checkout main

cat now.sh
#!/usr/bin/env bash

set -euo pipefail

now(){
   date '+%Y/%m/%d %H:%M:%S'
}

>&2 printf "[ %s %s ] Start\n" $(now)
sleep 2
>&2 printf "[ %s %s ] End\n" $(now)

exit 0
```

Once we are happy with the modified `now.sh` script, we can merge `now_add_echo` to `main`.

```bash
git checkout main
git merge now_add_echo
Updating eac414a..9c3f973
Fast-forward
 now.sh | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

# changes made in `now_add_echo` can be seen in `main`
cat now.sh
#!/usr/bin/env bash

set -euo pipefail

now(){
   date '+%Y/%m/%d %H:%M:%S'
}

# seconds to sleep
s=2

>&2 printf "[ %s %s ] Start\n" $(now)
>&2 echo Sleeping for ${s} seconds
sleep ${s}
>&2 printf "[ %s %s ] End\n" $(now)

exit 0
```

Finally we will delete the `now_add_echo` branch.

```bash
git branch -d now_add_echo
Deleted branch now_add_echo (was 9c3f973).

git branch
* main
  test_gh_actions
```

For more information, see [Git Branching - Basic Branching and Merging](https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging).

### Renaming a branch

See [How To Rename Your Git Repositories From Master to Main](https://hackernoon.com/how-to-rename-your-git-repositories-from-master-to-main-6i1u3wsu).

Step 1: Rename your local master branch

```bash
git branch -m master main
```

Step 2: Rename your remote master branch

Note that it is not possible to "rename" a remote branch in Git. We will create a new "main" branch and delete the old "master" branch.

```bash
git checkout main
git push origin main
git push origin --delete master
```

The delete step will not work for GitHub until you change the default branch from "master" to "main".

Step 3: Create new tracking connection

```bash
git fetch
git branch -u origin/main
```

### Default git init branch

Use `git config`.

```bash
git config --global init.defaultBranch main
```

Check changes.

```bash
git config --global --list | grep defaultbranch
init.defaultbranch=main
```

The initial default branch is now `main`.

```bash
git init
git status
On branch main

No commits yet

nothing to commit (create/copy files and use "git add" to track)
```

### HEAD

HEAD can be [considered](https://stackoverflow.com/questions/2304087/what-is-head-in-git) as the "current branch" and you can check what HEAD points to by checking `.git/HEAD`.

```bash
cat .git/HEAD
ref: refs/heads/main
```

When we switch branches, the HEAD revision changes to point to the tip of the new branch.

```bash
git checkout -b head_check
Switched to a new branch 'head_check'

cat .git/HEAD
ref: refs/heads/head_check
```

HEAD can point to any commit and it does not need to be the last commit in any branch. When HEAD points to a commit that is not the last commit in a branch, it is a detached HEAD. [In addition](https://www.sbf5.com/~cduan/technical/git/git-1.shtml#heads):

>A head is simply a reference to a commit object. Each head has a name (branch name or tag name, etc). By default, there is a head in every repository called master. A repository can contain any number of heads. At any given time, one head is selected as the "current head." This head is aliased to HEAD and is always in capitals. Note this difference: a "head" (lowercase) refers to any one of the named heads in the repository; "HEAD" (uppercase) refers exclusively to the currently active head. This distinction is used frequently in Git documentation.

## Tagging

Git has the ability to [tag specific points](https://git-scm.com/book/en/v2/Git-Basics-Tagging) in a repository’s history as being important. Typically, people use this functionality to mark release points (v1.0, v2.0 and so on).

List tags.

```console
git tag
```

You can also search for tags that match a particular pattern.

```console
git tag -l "v1.8.5*"
```

Git supports two types of tags:

1. lightweight and
2. annotated.

A lightweight tag is very much like a branch that doesn't change — it's just a pointer to a specific commit.

Annotated tags, however, are stored as full objects in the Git database. They are checksummed; contain the tagger name, email, and date; have a tagging message; and can be signed and verified with GNU Privacy Guard (GPG). It is generally recommended that you create annotated tags so you can have all this information; but if you want a temporary tag or for some reason don't want to keep the other information, lightweight tags are available too.

The easiest way to create an annotated tag is to specify `-a` when you run the tag command. The `-m` specifies a tagging message, which is stored with the tag. If you don't specify a message for an annotated tag, Git launches your editor so you can type it in.

```console
git tag -a v1.4 -m "my version 1.4"
```

You can see the tag data along with the commit that was tagged by using the `git show` command.

```console
git show v1.4
```

By default, the `git push` command doesn't transfer tags to remote servers. You will have to explicitly push tags to a shared server after you have created them. This process is just like sharing remote branches — you can run `git push origin <tagname>`.

```console
git push origin v1.5
```

If you have a lot of tags that you want to push up at once, you can also use the `--tags` option to the `git push` command. This will transfer all of your tags to the remote server that are not already there.

```console
git push origin --tags
```

To delete a tag on your local repository, you can use `git tag -d <tagname>`.

```console
git tag -d v1.4-lw
```

To delete a remote tag.

```console
git push origin --delete <tagname>
```

If you want to view the versions of files a tag is pointing to, you can do a `git checkout` of that tag, although this puts your repository in "detached HEAD" state.

```console
git checkout v2.0.0
```

## Remotes

[Remote repositories](https://git-scm.com/book/en/v2/Git-Basics-Working-with-Remotes) are versions of your project that are hosted on the Internet or network somewhere. In the push command in the getting started section, we used GitHub as our remote repository. You can have more than one remote repository that you can read and write to. For this repository there is one remote at GitHub that I can read and write to:

```console
git remote -v
```
```
origin	git@github.com:davetang/getting_started_with_git.git (fetch)
origin	git@github.com:davetang/getting_started_with_git.git (push)
```

If you change your username on the code repository, you need to update the remote URL locally with `git remote set-url`.

```console
git remote set-url origin git@github.com:newusername/getting_started_with_git.git
```

When we create a new repository on GitHub, we get the following instructions:

```bash
echo "# name_of_repo" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:davetang/name_of_repo.git
git push -u origin main
```

The `git remote add origin` sets the upstream name to `origin`, which is an alias to the remote repository connected to our local repository. The `git push -u origin main` pushes our local `main` branch to our remote repository; the `-u` is short for `--set-upstream`. This creates a tracking branch, which are local branches that have a direct relationship to a remote branch. Once this has been set up, you can simply type `git push` or `git pull` and Git automatically knows which server and branch to push to and pull from. The syntax for a tracking branch is `remotename/branch`.

When we [renamed a branch](#renaming-a-branch) from `master` to `main`, we had to create a new tracking connection for the newly renamed branch.

```bash
git branch -u origin/main
```
Note the same `-u` parameter and the tracking branch syntax used with `git branch`.

## Useful commands

Checking the history; this is why it is useful to add commit message to each commit!

```bash
git log
```

Checking out a specific commit to see what changes were made in that commit.

```bash
# the long string is called a hash that is associated with a commit
# you can get this hash from git log
git show 236e30511407bc2a22657972e4890789039c0863
```

Comparing two commits.

```bash
# depending on the order, differences will be either added or deleted
git diff 473679b4d1fc3497fb7b588086addf81425355ad 74fbc521bd371770ec3cf730c62eff06c0a1da53
```

List all configurations. At the bare minimum, you should always configure your `user.name` and `user.email`

```bash
git config -l

# add user.name and user.email if you haven't already
git config --global user.name "Dave Tang"
git config --global user.email "davetingpongtang@gmail.com"
```

### Show history of a file

This is useful for example when the latest version of a file has removed some code/text that you would like to restore.

```bash
git log -p -- my_file
```

The `-p` parameter is used to [show the difference](https://stackoverflow.com/questions/1964142/how-can-i-list-all-the-different-versions-of-a-file-and-diff-them-also) between each revision and its parent. The [double dash](https://unix.stackexchange.com/questions/11376/what-does-double-dash-mean) `--` is used in commands to signify the end of command options and anything after is/are treated as positional arguments. In the example above, the only option we want is `-p` and the `--` indicates that the next item is the `<path>` to the file.

### List all tracked files

List all files currently tracked under the `main` branch.

```bash
git ls-tree -r main
```

### List all files that were tracked

List all files that are and were tracked.

```bash
git log --pretty=format: --name-only --diff-filter=A
```

## Undoing things

Git makes it easy to recover a file if you accidentally deleted it or get rid of changes that you just made with `git restore`; see [Unmodifying a modified file](https://git-scm.com/book/en/Git-Basics-Undoing-Things) for more information.

Recover an accidentally deleted file (that has not been committed).

```bash
rm now.sh

git status
# On branch main
# Your branch is up to date with 'origin/main'.
# 
# Changes not staged for commit:
#   (use "git add/rm <file>..." to update what will be committed)
#   (use "git restore <file>..." to discard changes in working directory)
#         deleted:    now.sh
# 
# no changes added to commit (use "git add" and/or "git commit -a")

git restore now.sh
```

Removing changes with the same command.

```bash
echo blah >> now.sh

git status
# On branch main
# Your branch is up to date with 'origin/main'.
# 
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#   (use "git restore <file>..." to discard changes in working directory)
#         modified:   now.sh
# 
# no changes added to commit (use "git add" and/or "git commit -a")

git restore now.sh
```

Use `checkout` with the `-f` option to throw away all local modifications.

```bash
git checkout -f
```

### Git reset

Notes from [Git Tools - Reset
Demystified](https://git-scm.com/book/en/v2/Git-Tools-Reset-Demystified) and
[Resetting, Checking Out and
Reverting](https://www.atlassian.com/git/tutorials/resetting-checking-out-and-reverting).

A reset is an operation that takes a specified commit and resets [The Three
Trees](#the-three-trees) to match the state of the repository at that specified
commit. A reset can be invoked in three different modes, which correspond to
the three trees.

[Checkout](#git-checkout) and reset are generally used for making local or
private changes. They modify the history of a repository that can cause
conflicts when pushing to remote. [Revert](#git-revert) is considered a safe
operation for "public undos" as it creates new history that can be shared
remotely and does not overwrite history that remote users may be dependent on.
`git reset` is a simple way to undo changes that haven't been shared with
anyone else.

Parameters used with `git reset` determine its scope; when a file path is not
used, reset operates on whole commits.

To move backwards two commits on the `hotfix` branch, i.e. throw away the last
two commits.

```bash
git checkout hotfix git reset HEAD~2
```

The two commits that were on the end of `hotfix` are orphaned commits and will
be deleted next time Git performs a garbage collection.

`git reset` can alter the staged snapshot (Index in the three trees) and/or the
working directory when used with one of the following flags:

* `--soft` - the staged snapshot and working directory are not altered in any way.
* `--mixed` - the staged snapshot is updated to match the specified commit, but
the working directory is not affected. This is the default.
* `--hard` - the staged snapshot and the working directory are both updated to
match the specified commit.

Reset latest change.

```console
git reset --soft HEAD^

# Optional
# force push to main
# git push origin +main
```

Use `reset --hard` to reset HEAD, index and working directory.

```bash
git reset --hard
```

When `git reset` is used with a file path, the staged snapshot is updated to
match the version from the specified commit.

### Git clean

Use `clean` to [remove untracked files](https://stackoverflow.com/questions/61212/how-to-remove-local-untracked-files-from-the-current-git-working-tree).

Create an untracked file.

```bash
touch test.txt

git status
# On branch main
# Your branch is up to date with 'origin/main'.
# 
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#         test.txt
# 
# nothing added to commit but untracked files present (use "git add" to track)
```

Use `--dry-run` first to see what would be deleted.

```bash
git clean --dry-run
# Would remove test.txt
```

Remove untracked files.

```bash
git clean -f
# Removing test.txt
```

Remove untracked directories.

```bash
mkdir blah
touch blah/test.txt

git clean -fd
# Removing blah/
```

### Git revert

[Git
revert](https://www.atlassian.com/git/tutorials/resetting-checking-out-and-reverting)
is an operation that takes a specified commit and creates a new commit which
inverses the specified commit. `git revert` can only be run at a commit level
scope and has no file level functionality.

Let's create a commit that we will revert.

```bash
echo bad > bad.txt
git add bad.txt
git commit -m 'Add bad.txt'

git log --oneline | head -5
dfaccc3 Add bad.txt
37e3241 Note about HEAD
60c4eb6 Branching example
9c3f973 echo sleep time
eac414a Merge branch 'main' of github.com:davetang/getting_started_with_git into main
```

We can use [HEAD](#head) to refer to the latest commit and revert this. Note
that the "bad" commit still exists in the commit history, we simply created a
new commit that reverted the last commit.

```bash
git revert HEAD

git log --oneline | head -5
1e3d615 Revert "Add bad.txt"
dfaccc3 Add bad.txt
37e3241 Note about HEAD
60c4eb6 Branching example
9c3f973 echo sleep time
```

`bad.txt` no longer exists in the working directory but we could recover in the
future if we wanted.

```bash
ls bad.txt
ls: cannot access bad.txt: No such file or directory
```

Use `git log` to find the commit that created `bad.txt` then use `git checkout commit` to go back to that particular commit.

```console
git checkout dfaccc3ed393fe3e647c80bf2211b768d25d040f
ls bad.txt
```
```
bad.txt
```

Finally, go back to the tip.

```console
git checkout main
```
```
Previous HEAD position was dfaccc3 Add bad.txt
Switched to branch 'main'
```

## Submodules

[Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) allow you to keep a Git repository as a subdirectory of another Git repository. This lets you clone another repository into your project and keep your commits separate.

To include another repo as a submodule; a new `.gitmodules` configuration file will be generated.

```bash
git submodule add URL

cat .gitmodules
```

When cloning a repo with submodules, you can use `--recurse-submodules` with `git clone` and each submodule will automatically initialise and update.

```bash
git clone --recurse-submodules URL
```

Or run these three commands to initialise and update each submodule.

```bash
git clone URL
git submodule init
git submodule update
```

To pull all submodules for a repository with submodules.

```bash
git submodule update --init --recursive
```

To update submodules.

```bash
git submodule update --recursive --remote
```

# GitHub

## GitHub CLI

Download appropriate binary from the GitHub CLI [releases page](https://github.com/cli/cli/releases).

```console
wget https://github.com/cli/cli/releases/download/v2.55.0/gh_2.55.0_linux_amd64.tar.gz
```

Generate a Personal Access Token at <https://github.com/settings/tokens>:

1. Click on Generate new token
2. Note = GitHub CLI
3. Tick: `repo`, `read:org`
4. Generate token
5. Copy token

To get started with GitHub CLI.

```console
gh auth login
```
```
? What account do you want to log into? GitHub.com
? What is your preferred protocol for Git operations on this host? SSH
? Generate a new SSH key to add to your GitHub account? No
? How would you like to authenticate GitHub CLI? Paste an authentication token
Tip: you can generate a Personal Access Token here https://github.com/settings/tokens
The minimum required scopes are 'repo', 'read:org'.
? Paste your authentication token: ****************************************
- gh config set -h github.com git_protocol ssh
✓ Configured git protocol
! Authentication credentials saved in plain text
✓ Logged in as davetang
```

Create new GitHub repository interactively

```console
gh repo create
```
```
? What would you like to do? Create a new repository on GitHub from scratch
? Repository name misc
? Repository owner davetang
? Description Miscellaneous notes and tips
? Visibility Public
? Would you like to add a README file? Yes
? Would you like to add a .gitignore? No
? Would you like to add a license? Yes
? Choose a license Creative Commons Zero v1.0 Universal
? This will create "misc" as a public repository on GitHub. Continue? Yes
✓ Created repository davetang/misc on GitHub
  https://github.com/davetang/misc
? Clone the new repository locally? No
```

## GitHub Actions

In [this guide](https://docs.github.com/en/actions/quickstart), you'll add a workflow that demonstrates some of the essential features of GitHub Actions. Read [Understanding GitHub Actions](https://docs.github.com/en/actions/learn-github-actions/understanding-github-actions) for more information.

Firstly, create a new branch.

```bash
git checkout -b test_gh_actions
```

Create `.github/workflows`.

```bash
mkdir -p .github/workflows

git branch
  master
* test_gh_actions
```

Create `.github/workflows/github-actions-demo.yml` and populate it with the following.

```
name: GitHub Actions Demo
on: [push]
jobs:
  Explore-GitHub-Actions:
    runs-on: ubuntu-latest
    steps:
      - run: echo "The job was automatically triggered by a ${{ github.event_name }} event."
      - run: echo "This job is now running on a ${{ runner.os }} server hosted by GitHub!"
      - run: echo "The name of your branch is ${{ github.ref }} and your repository is ${{ github.repository }}."
      - name: Check out repository code
        uses: actions/checkout@v2
      - run: echo "The ${{ github.repository }} repository has been cloned to the runner."
      - run: echo "The workflow is now ready to test your code on the runner."
      - name: List files in the repository
        run: |
          ls ${{ github.workspace }}
      - run: echo "This job's status is ${{ job.status }}."
```

Add, commit, push.

```bash
git add .github/workflows/github-actions-demo.yml
git commit -m 'GitHub Actions yml file'
git push origin test_gh_actions
```

Create a pull request for `test_gh_actions` on GitHub and merge after review.

### Encrypted secrets

[Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets) are encrypted environment variables that are created in an organisation, repository, or repository environment. The secrets are available to use in GitHub Actions workflows and uses a [libsodium sealed box](https://libsodium.gitbook.io/doc/public-key_cryptography/sealed_boxes) to ensure that secrets are encrypted before they reach GitHub and remain encrypted until you use them in a workflow.

Secret names can only contain alphanumeric characters, must not start with the `GITHUB_` prefix or numbers, are **not** case-sensitive, and must be unique at the level they are created at.

To make a secret available to an action, you must set the secret as an input or environment variable in the workflow file. To create a secret, go to your repository then `Settings` -> `Secrets` -> `Actions` and click on `New repository secret`. Then enter the `Name` of your secret, for example, `MAIL_PASSWORD` or `MAIL_USERNAME`, and then the `Value` you want associated with the secret key. You can then use these secrets in your workflow:

```
      - name: Send email
        env:
          MAIL_USERNAME: ${{ secrets.MAIL_USERNAME }}
          MAIL_PASSWORD: ${{ secrets.MAIL_PASSWORD }}
```

If you try to print the secret out like so:

```
      - name: Check secret
        env:
          TOP_SECRET: ${{ secrets.TOP_SECRET }}
        run: echo ${TOP_SECRET}
```

You will see [hunter2](http://bash.org/?244321).

### Safe directory

The [CVE-2022-24765 vulnerability](https://github.blog/2022-04-12-git-security-vulnerability-announced/), which allows someone else to override your git config, now causes the [following error](https://github.com/actions/checkout/issues/760):

```
fatal: unsafe repository ('/__w/repo/repo' is owned by someone else)
To add an exception for this directory, call:

  git config --global --add safe.directory /__w/repo/repo
  Error: Process completed with exit code 128.
```

The latest version of Git now checks whether a repository is owned by you and if not, you will get the error above. This is a problem when using Docker with GitHub Actions, since your user id will be different (inside Docker, your `uid` is `0(root)`). Currently, the easiest way around this is to run the `git config` step as suggested by the error, where `repo` is the name of your GitHub repository.

Another way around this is to change your container `uid` to match the `actions-runner-controller`, which is [apparently 1000](https://github.com/actions/checkout/issues/760#issuecomment-1097797031).

# Aliases

The [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh) framework has a long list of Git aliases (see `ohmyzsh_git_aliases.sh`) that can save you some typing. Here are the ones that I use the most often.

```console
alias g='git'
alias ga='git add'
alias gb='git branch'
alias gco='git checkout'
alias gclean='git clean --interactive -d'
alias gcl='git clone --recurse-submodules'
alias gcmsg='git commit --message'
alias gcf='git config --list'
alias gd='git diff'
alias gf='git fetch'
alias gfo='git fetch origin'
alias ghh='git help'
alias glgg='git log --graph'
alias gm='git merge'
alias gl='git pull'
alias gp='git push'
alias gpd='git push --dry-run'
alias grf='git reflog'
alias gr='git remote'
alias grv='git remote --verbose'
alias gra='git remote add'
alias grh='git reset'
alias grs='git restore'
alias grm='git rm'
alias gst='git status'
alias gsw='git switch'
```

# Terminology

## Downstream and upstream

[In terms of source control](https://stackoverflow.com/questions/2739376/definition-of-downstream-and-upstream), you're downstream when you copy (clone, checkout, etc) from a repository. Information flowed "downstream" to you.

When you make changes, you usually want to send them back "upstream" so they make it into that repository so that everyone pulling from the same source is working with all the same changes. This is mostly a social issue of how everyone can coordinate their work rather than a technical requirement of source control. You want to get your changes into the main project so you're not tracking divergent lines of development.

Sometimes you'll read about package or release managers (the people, not the tool) talking about submitting changes to "upstream". That usually means they had to adjust the original sources so they could create a package for their system. They don't want to keep making those changes, so if they send them "upstream" to the original source, they shouldn't have to deal with the same issue in the next release.

 "Download" and "upload" are verbs. "Upstream" and "downstream" describe a relative position.

# Useful links

* [Version Control with Git](https://swcarpentry.github.io/git-novice/) by Software Carpentry Foundation
* [Pro Git book](https://git-scm.com/book/en/v2)
* [A Quick Introduction to Version Control with Git and GitHub](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1004668)
* [Ten Simple Rules for Taking Advantage of Git and GitHub](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1004947)
* [Resources to learn Git](https://try.github.io/)
* Karl Broman's [git/github guide](https://kbroman.org/github_tutorial/)
* [GitHub Actions Cheat Sheet](https://resources.github.com/whitepapers/GitHub-Actions-Cheat-sheet/)
* [Bioinformatics Data Skills](http://shop.oreilly.com/product/0636920030157.do) chapter 5 "Git for Scientists"
* My [Git Wiki page](https://davetang.org/wiki2/index.php?title=Git)
* My old [blog post](https://davetang.org/muse/2013/09/04/getting-started-with-git/)
* [Git merge conflicts](https://www.atlassian.com/git/tutorials/using-branches/merge-conflicts)
