# Stuff not to do

Inspired by [How to get somebody fired using Git](https://dev.to/mauroaccorinti/how-to-get-somebody-fired-using-git-31if).

## Setup

1. Create new repository on own GitLab instance.
2. Clone `git clone git@local:davetang/spaghetti.git && cd spaghetti`
3. Create ten commits.

```console
for I in {1..10}; do echo ${I} > ${I}.txt; git add ${I}.txt; git commit -m "Add ${I}"; done
```

4. Push `git push`

History.

```console
git log | grep commit
```
```
commit c07033c742ade01082c780f41c59792a6034a47b
commit 8c39ad78578266c0eeb8f1c8a7716e6cc7dc3307
commit 0f53b4ffc0cad50f0b7e6a09b9f54c8306cc9138
commit 80031907beb935c3f4fd36e78aee0773499ae107
commit 19aff22e9d0f06055f07f8f0731cd75fbf4e0577
commit 133bb18a4901d070596cfaf3db64a47a17882d07
commit 2a9bcf2eaff2cb1b5bad354ae35c36616c36ae3f
commit 7c7bc9dac732d3aa04ab425a766784352e0a49be
commit 062998222ec4422b9fa078933d839361e3b3cf42
commit c0d04d1b8b800853b6c9554fdd4e9bb795150204
```

## Force push to main

Checkout a previous commit and make a new commit then try to push.

```console
git checkout 80031907beb935c3f4fd36e78aee0773499ae107
echo 1984 > 1984.txt
git add 1984.txt
git push
```
```
fatal: You are not currently on a branch.
To push the history leading to the current (detached HEAD)
state now, use

    git push origin HEAD:<name-of-remote-branch>
```

Push to `main`!

```console
git push origin HEAD:main
```
```
To local:davetang/spaghetti.git
 ! [rejected]        HEAD -> main (non-fast-forward)
error: failed to push some refs to 'local:davetang/spaghetti.git'
hint: Updates were rejected because a pushed branch tip is behind its remote
hint: counterpart. Check out this branch and integrate the remote changes
hint: (e.g. 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```

Good to know!

```console
git push --force origin HEAD:main
```
```
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Delta compression using up to 6 threads
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 271 bytes | 271.00 KiB/s, done.
Total 3 (delta 1), reused 0 (delta 0), pack-reused 0
remote: GitLab: You are not allowed to force push code to a protected branch on this project.
To local:davetang/spaghetti.git
 ! [remote rejected] HEAD -> main (pre-receive hook declined)
error: failed to push some refs to 'local:davetang/spaghetti.git'
```
