## Table of Contents

- [Stuff not to do](#stuff-not-to-do)
  - [Setup](#setup)
  - [Force push to main](#force-push-to-main)
  - [Resetting](#resetting)
- [Merging versus rebasing](#merging-versus-rebasing)
- [Can I revert a commit when I pushed to remote?](#can-i-revert-a-commit-when-i-pushed-to-remote)
- [Working a separate branch while main gets updated](#working-a-separate-branch-while-main-gets-updated)

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

## Resetting

Make some change.

```console
echo 11 > 11.txt
git add 11.txt
git commit -m 'Add 11'
```

Soft reset leaves file staged.

```console
git reset --soft c07033c742ade01082c780f41c59792a6034a47b
git status .
```
```
On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        new file:   11.txt
```

Mixed reset (also the default) leaves file unstaged as well.

```console
git reset --mixed c07033c742ade01082c780f41c59792a6034a47b
git status .
```
```
git status .
On branch main
Your branch is up to date with 'origin/main'.

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        11.txt

nothing added to commit but untracked files present (use "git add" to track)
```

Hard reset is evil! Erases all changes up until the specified commit!

```console
git reset --hard 8c39ad78578266c0eeb8f1c8a7716e6cc7dc3307
```
```
HEAD is now at 8c39ad7 Add 9
```

Commit c07033c742ade01082c780f41c59792a6034a47b is gone!

```console
git log | grep commit
```
```
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

But good to know that we can't force push after a hard reset.

```console
git push --force
```
```
Total 0 (delta 0), reused 0 (delta 0), pack-reused 0
remote: GitLab: You are not allowed to force push code to a protected branch on this project.
To local:davetang/spaghetti.git
 ! [remote rejected] main -> main (pre-receive hook declined)
error: failed to push some refs to 'local:davetang/spaghetti.git'
```

# Merging versus rebasing

Inspired by [Git Merge vs. Rebase: Key Differences](https://dev.to/codeparrot/git-merge-vs-rebase-key-differences-1pb4).

Using the same [setup](#setup), checkout at 0f53b4ffc0cad50f0b7e6a09b9f54c8306cc9138, create a new branch, and add some commits.

```console
git checkout 0f53b4ffc0cad50f0b7e6a09b9f54c8306cc9138
git switch -c new_feature

for I in {20..24}; do echo ${I} > ${I}.txt; git add ${I}.txt; git commit -m "Add ${I}"; done
```

Merge.

```console
git checkout main
git merge new_feature
git log
```
```
commit 083f03b322835824610d79294a40f5225655aa2b (HEAD -> main)
Merge: c07033c e76ae5b
Author: Dave Tang <davetingpongtang@gmail.com>
Date:   Thu Apr 25 21:09:52 2024 +0900

    Merge branch 'new_feature'

commit e76ae5b85905cda637b00af9d34903d1a305182c (new_feature)
Author: Dave Tang <davetingpongtang@gmail.com>
Date:   Thu Apr 25 21:08:57 2024 +0900

    Add 24

commit 096415d9d0a64367650f42242a46b426850d06f7
Author: Dave Tang <davetingpongtang@gmail.com>
Date:   Thu Apr 25 21:08:57 2024 +0900

    Add 23

commit 9f3b54ecd78b6d3be15135e37235030f52d74bc1
Author: Dave Tang <davetingpongtang@gmail.com>
Date:   Thu Apr 25 21:08:57 2024 +0900

    Add 22

commit 70efda7bac906e6fe0f65e5a40e7951502cc807f
Author: Dave Tang <davetingpongtang@gmail.com>
Date:   Thu Apr 25 21:08:57 2024 +0900

    Add 21

commit 8b139f368e47ca2690ad71fc86a849099090d246
Author: Dave Tang <davetingpongtang@gmail.com>
Date:   Thu Apr 25 21:08:57 2024 +0900

    Add 20

commit c07033c742ade01082c780f41c59792a6034a47b (origin/main)
Author: Dave Tang <davetingpongtang@gmail.com>
Date:   Tue Apr 23 23:13:24 2024 +0900

    Add 10
```

Reset and try rebase.

```console
git reset c07033c742ade01082c780f41c59792a6034a47b
git log
```
```
commit c07033c742ade01082c780f41c59792a6034a47b (HEAD -> main, origin/main)
Author: Dave Tang <davetingpongtang@gmail.com>
Date:   Tue Apr 23 23:13:24 2024 +0900

    Add 10
```

Same as before.

```console
git checkout 0f53b4ffc0cad50f0b7e6a09b9f54c8306cc9138
git switch -c new_feature2

for I in {30..34}; do echo ${I} > ${I}.txt; git add ${I}.txt; git commit -m "Add ${I}"; done
```

Rebase.

```console
git rebase main
git log
```
```
commit 23098fd333883881990eda4e2c5dfd9b872bf7bb (HEAD -> new_feature2)
Author: Dave Tang <davetingpongtang@gmail.com>
Date:   Thu Apr 25 21:14:29 2024 +0900

    Add 34

commit dbffdd303fffeb1dbff52bfaeca41d1d1e8030a7
Author: Dave Tang <davetingpongtang@gmail.com>
Date:   Thu Apr 25 21:14:29 2024 +0900

    Add 33

commit 62f62eaee2c80410d041b69af22d71fb8aa1198f
Author: Dave Tang <davetingpongtang@gmail.com>
Date:   Thu Apr 25 21:14:29 2024 +0900

    Add 32

commit 8fb56fa27a1be6a34618f28f3acd64c1f18b40f7
Author: Dave Tang <davetingpongtang@gmail.com>
Date:   Thu Apr 25 21:14:29 2024 +0900

    Add 31

commit 2f0013ecf0b32c2297fc32077cccfac999f40e83
Author: Dave Tang <davetingpongtang@gmail.com>
Date:   Thu Apr 25 21:14:29 2024 +0900

    Add 30

commit c07033c742ade01082c780f41c59792a6034a47b (origin/main, main)
Author: Dave Tang <davetingpongtang@gmail.com>
Date:   Tue Apr 23 23:13:24 2024 +0900

    Add 10
```

# Can I revert a commit when I pushed to remote?

Create and switch to new branch, add file, commit, and push.

```console
git switch -c test_revert
echo 1984 > seed.txt
git add seed.txt
git commit -m 'Add text file containing seed'
git push --set-upstream origin test_revert
```

Revert.

```console
git revert HEAD
```
```
[test_revert 93f2859] Revert "Add text file containing seed"
 1 file changed, 1 deletion(-)
 delete mode 100644 seed.txt
```

If I push, then there are two commits. This may be desirable to keep the history intact.

```console
git push
```

What if I want to completely remove that commit?

```console
git switch -c test_revert2
echo 1984 > seed.txt
git add seed.txt
git commit -m 'Add text file containing seed'
git push --set-upstream origin test_revert2
```

Throw out your local changes! This deletes `seed.txt`!

```console
git reset --hard origin/main
```
```
HEAD is now at d3b69e4 Fix conflict
```

Try to push.

```console
git push
```
```
To local:davetang/test_repo
 ! [rejected]        test_revert2 -> test_revert2 (non-fast-forward)
error: failed to push some refs to 'local:davetang/test_repo'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. Integrate the remote changes (e.g.
hint: 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```

Push with force! (Not recommended!)

```console
git push --force
```

Commit gone from local and remote.

# Working a separate branch while main gets updated

Create new branch.

```console
git switch -c update_from_main
```

Switch back to `main`, make a change, and push to remote.

```console
git switch main
echo something > test2.txt
git add test2.txt
git commit -m 'Add test2.txt'
git push origin main
```

Switch back to `update_from_main` and try to pull.

```console
git switch update_from_main
git pull
```
```
There is no tracking information for the current branch.
Please specify which branch you want to merge with.
See git-pull(1) for details.

    git pull <remote> <branch>

If you wish to set tracking information for this branch you can do so with:

    git branch --set-upstream-to=origin/<branch> update_from_main
```

Pull from `main`, which is actually running `git fetch` and `git merge`. The file added on `main` will be available in `update_from_main`.

```console
git pull origin main
cat test2.txt
```
```
something
```
