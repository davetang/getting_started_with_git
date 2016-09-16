Getting started with Git
========================

Git is an open source distributed version control system.

Clone this repository:

~~~~{.bash}
git clone https://github.com/davetang/getting_started_with_git.git
~~~~

# Getting started

In Git, there are three main stages that a file can reside in: committed, modified, and staged. **Committed** means that the data is safely stored in your local database. **Modified** means that you have changed the file but have not committed it to your database yet. **Staged** means that you have marked a modified file in its current version to go into your next commit snapshot.

Firstly, configure your name and email:

~~~~{.bash}
git config --global user.name "Dave Tang"
git config --global user.email "me@davetang.org"
~~~~

The Git directory is where Git stores the metadata and object database for your project; the working directory is a single checkout of one version of the project. This is the most important part of Git, and it is what is copied when you clone a repository from another computer. To initialise a repository/directory:

~~~~{.bash}
git init
~~~~

The basic Git workflow goes something like this:

1. You modify files in your working directory
2. You stage the files, adding snapshots of them, to your staging area
3. You perform a commit, which takes the files as they are in the staging area and stores that snapshot permanently to your Git directory

To check the stage that a file is in, use:

~~~~{.bash}
git status
~~~~

To stage a file, use [git-add](https://git-scm.com/docs/git-add):

~~~~{.bash}
echo hello > hello.txt
git add hello.txt 
~~~~

To perform the commit, use [git-commit](https://git-scm.com/docs/git-commit):

~~~~{.bash}
git commit -m "Hello, is it me you're looking for"
~~~~

To **push** out local repository to the GitHub server, log into GitHub and create a new repository, then:

~~~~{.bash}
git remote add origin git@github.com:davetang/your_new_repo.git
git push origin master
~~~~

# Common tasks

Checking the history:

~~~~{.bash}
git log
~~~~

Checking a specific commit:

~~~~{.bash}
# get hash from git log
git show 8bccd8c4583e1ebd02cc42073e97f166579357ff
~~~~

Comparing two commits:

~~~~{.bash}
# depending on the order, differences will be either added or deleted
git diff 41363461e259641111acb692217130f62c9648fa 8bccd8c4583e1ebd02cc42073e97f166579357ff
~~~~

List all configurations:

~~~~{.bash}
git config -l
~~~~

# Undoing things

[Unmodifying a modified file](http://git-scm.com/book/en/Git-Basics-Undoing-Things)

~~~~{.bash}
ls
# hello.txt

git status
# On branch master
# nothing to commit, working directory clean

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

git checkout -- hello.txt
git status
# On branch master
# nothing to commit, working directory clean
~~~~

[Throwing out all changes](http://gitready.com/beginner/2009/01/11/reverting-files.html)

~~~~{.bash}
git checkout -f
# or
git reset --hard
~~~~

[Removing untracked files](http://stackoverflow.com/questions/61212/how-do-i-remove-local-untracked-files-from-my-current-git-branch)

~~~~{.bash}
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
~~~~

Revert a commit

~~~~{.bash}
# removes the commit for hello.txt
git revert 5fc21f9beef4cfb3a9d834e843b3a5848e6fe05d

# reverts the revert, restoring helo.txt
git revert 003422db0129c4e68a8dd7d86652c6b4b40f0038
~~~~

# Tutorials

* [tryGit](https://try.github.io/levels/1/challenges/1) created by Code School
* Check out Karl Broman's git/github guide at <http://kbroman.org/github_tutorial/>
* Chapter 5 Git for Scientists in [Bioinformatics Data Skills](http://shop.oreilly.com/product/0636920030157.do)

# Links

* My [blog post](http://davetang.org/muse/2013/09/04/getting-started-with-git/)
* My [Git Wiki page](http://davetang.org/wiki2/index.php?title=Git)

