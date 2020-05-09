## README

Table of Contents
=================

      * [README](#readme)
      * [Getting started](#getting-started)
      * [Branches](#branches)
      * [Remotes](#remotes)
      * [Useful commands](#useful-commands)
      * [Undoing things](#undoing-things)
      * [Links](#links)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

[Git](https://git-scm.com/) is an open source distributed version control system. [GitHub](https://github.com/) is an online repository where you can store your projects that use Git for its version controlling. There are many advantages to using version control and it is not too difficult to start using Git and GitHub. Furthermore, GitHub isn't just for storing code! I use it a lot just to store my study notes, which I like to share just in case they are useful to others.

You can clone this repository and make your own additional notes to this document (written in [Markdown](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)).

```bash
git clone https://github.com/davetang/getting_started_with_git.git
```

## Getting started

First thing is to [install Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) if you haven't already. Once installed, configure your name and email.

```bash
git config --global user.name "Dave Tang"
git config --global user.email "davetingpongtang@gmail.com"
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

## Remotes

[Remote repositories](https://git-scm.com/book/en/v2/Git-Basics-Working-with-Remotes) are versions of your project that are hosted on the Internet or network somewhere. In the push command in the getting started section, we used GitHub as oure remote repository. You can have more than one remote repository that you can read and write to.

```bash
# for this repository there is one remote at GitHub that I can read and write to
git remote -v
origin  https://github.com/davetang/getting_started_with_git.git (fetch)
origin  https://github.com/davetang/getting_started_with_git.git (push)
```

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

## Undoing things

Git makes it easy to recover a file if you accidentally deleted it or get rid of changes that you just made.

[Unmodifying a modified file](https://git-scm.com/book/en/Git-Basics-Undoing-Things)

```bash
ls
# hello.txt

git status
# On branch master
# nothing to commit, working directory clean

# make change to file
echo bye >> hello.txt
git status
# On branch master
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
# 
#         modified:   hello.txt
# 
# no changes added to commit (use "git add" and/or "git commit -a")

# get rid of change
git checkout -- hello.txt
git status
# On branch master
# nothing to commit, working directory clean
```

Throwing out all changes.

```bash
git checkout -f
# or
git reset --hard
```

[Removing untracked files](https://stackoverflow.com/questions/61212/how-to-remove-local-untracked-files-from-the-current-git-working-tree)

```bash
# create new untracked file
echo bye > bye.txt

ls
# bye.txt         hello.txt

git status
# On branch master
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
# 
#         bye.txt
# 
# nothing added to commit but untracked files present (use "git add" to track)

git clean -fd
# Removing bye.txt

ls
# hello.txt
```

Revert a commit.

```bash
# removes the commit for hello.txt
git revert 5fc21f9beef4cfb3a9d834e843b3a5848e6fe05d

# reverts the revert, restoring helo.txt
git revert 003422db0129c4e68a8dd7d86652c6b4b40f0038
```

## Useful links

* [tryGit](https://try.github.io/levels/1/challenges/1) created by Code School
* Check out Karl Broman's git/github guide at <http://kbroman.org/github_tutorial/>
* Chapter 5 Git for Scientists in [Bioinformatics Data Skills](http://shop.oreilly.com/product/0636920030157.do)
* My [Git Wiki page](http://davetang.org/wiki2/index.php?title=Git)
* My old [blog post](http://davetang.org/muse/2013/09/04/getting-started-with-git/) on Git when I was first learning about it

