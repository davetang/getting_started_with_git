# Cherry picking

In Git, cherry-picking is taking a single commit from one branch and adding it as the latest commit on another branch. The rest of the commits in the source branch are not added to the target. Cherry-pick a commit when you need the contents in a single commit, but not the contents of the entire branch.

## Setup

1. Create new repository on own GitLab instance.
2. Clone `git clone git@local/cherry_picking.git && cd cherry_picking`
3. Add `README.md`

```console
printf "# README\n\nTest cherry picking\n" > README.md
git add README.md
git commit -m 'Add README.md'
git push
```

4. Create new branch and switch.

```console
git switch -c 'branch_to_pick'
```

5. Create ten commits.

```console
for I in {1..10}; do echo ${I} > ${I}.txt; git add ${I}.txt; git commit -m "Add ${I}"; done
```

6. Push

```console
git push --set-upstream origin branch_to_pick
```

## How to pick just a single commit?

According to the [Cherry-pick changes](https://docs.gitlab.com/ee/user/project/merge_requests/cherry_pick_changes.html) document:

You can cherry-pick a single commit from multiple locations in your GitLab project. To cherry-pick a commit from the list of all commits for a project:

1. On the left sidebar, select Search or go to and find your project.
2. Select branch and then Code > Commits.
3. Select the title of the commit you want to cherry-pick.
4. In the upper-right corner, select Options > Cherry-pick.
5. On the cherry-pick dialog, select the project and branch to cherry-pick into.
6. Optional. Select Start a new merge request with these changes.
7. Select Cherry-pick.
8. Merge to main!

```console
git switch main
git pull
git log
```
```
commit 34b0412111d0858b04fd5ab8f780963be58053d7 (HEAD -> main, origin/main)
Merge: 0d25df6 4cbed7c
Author: Dave Tang <me@davetang.org>
Date:   Mon Jun 3 07:48:35 2024 +0000

    Merge branch 'cherry-pick-b1ef569c' into 'main'

    Add 5

    See merge request davetang/cherry_picking!2

commit 4cbed7c38a41aba52ec0035da47f2c32442f3d86
Author: Dave Tang <me@davetang.org>
Date:   Mon Jun 3 07:48:00 2024 +0000

    Add 5


    (cherry picked from commit b1ef569ca29b3b49c3408bd1215dfdf392931342)

    Co-authored-by: Dave Tang <davetingpongtang@gmail.com>

commit 0d25df6237355b33ad41bb3cb207f0ff73e267d6
Author: Dave Tang <davetingpongtang@gmail.com>
Date:   Mon Jun 3 16:35:04 2024 +0900

    Add README.md
```

Awesome!

What happens if I try to merge all the commits from `branch_to_pick` to `main` now?

After merging on GitLab.

```console
git switch main
git pull
git log
```

Output was too long and not shown. But the 10 commits from `branch_to_pick` were added before the cherry picked commit. And HEAD points to the merge commit of `branch_to_pick` and `main`.
