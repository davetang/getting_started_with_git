# README

Practice using Git using my GitLab instance.

## Scenario 1

Made `test_repo` that contains a single file `test.txt` that contains a single
word ("hi") on a single line. Pushed remotely to my own GitLab instance.

On computer 1, I will edit `test.txt` by adding "comp1" on top of "hi", so the
file looks like this:

```
comp1
hi
```

I will commit and push to remote.

```console
git add test.txt
git commit -m 'Add line from computer 1'
git push
```

On computer 2, I will edit `test.txt` by adding "comp2" on the bottom of "hi",
so the file looks like this:

```
hi
comp2
```

I will commit and push to remote (without pulling first).

```console
git add test.txt
git commit -m 'Add line from computer 2'
git push
```
```
To local:davetang/test_repo
 ! [rejected]        main -> main (fetch first)
error: failed to push some refs to 'local:davetang/test_repo'
hint: Updates were rejected because the remote contains work that you do
hint: not have locally. This is usually caused by another repository pushing
hint: to the same ref. You may want to first integrate the remote changes
hint: (e.g., 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```

As suggested, I will run `git pull` first.

```console
git pull
```
```
Merge branch 'main' of local:davetang/test_repo
# Please enter a commit message to explain why this merge is necessary,
# especially if it merges an updated upstream into a topic branch.
#
# Lines starting with '#' will be ignored, and an empty message aborts
# the commit.

Merge made by the 'ort' strategy.
 test.txt | 1 +
 1 file changed, 1 insertion(+)
```

Now I can run `git push`. The test file looks like this now on computer 2.

```console
cat test.txt
```
```
comp1
hi
```

## Scenario 2

Before continuing with this scenario, make sure `test_repo` is in sync on both
computers. `test.txt` should look like this on both computers:

```
comp1
hi
comp2
```

Now let's edit the same line on both computers! On computer 1, change "hi" to
"hi from comp1" and then commit and push.

```console
git add test.txt
git commit -m 'Saying hi from comp1'
git push
```

Now on computer 2, without pulling first, change "hi" to "hi from comp2" and
then commit and push.

```console
git add test.txt
git commit -m 'Saying hi from comp2'
git push
```
```
To local:davetang/test_repo
 ! [rejected]        main -> main (fetch first)
error: failed to push some refs to 'local:davetang/test_repo'
hint: Updates were rejected because the remote contains work that you do
hint: not have locally. This is usually caused by another repository pushing
hint: to the same ref. You may want to first integrate the remote changes
hint: (e.g., 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```

Again, let's run `git pull`.

```console
git pull
```
```
remote: Enumerating objects: 5, done.
remote: Counting objects: 100% (5/5), done.
remote: Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (3/3), 256 bytes | 128.00 KiB/s, done.
From local:davetang/test_repo
   d934289..9dbe692  main       -> origin/main
Auto-merging test.txt
CONFLICT (content): Merge conflict in test.txt
Automatic merge failed; fix conflicts and then commit the result.
```

Merging failed because we edited the same line! If we open up `test.txt` we
will see:

```
comp1
<<<<<<< HEAD
hi from comp2
=======
hi from comp1
>>>>>>> 9dbe6926db7e88d6f7c9daba2c04b5f287cd221b
comp2
```

Let's change the file so it looks like this:

```
comp1
hi from both comps
comp2
```

As suggested, let's commit!

```console
git commit -m 'Fix conflict'
```
```
U       test.txt
error: Committing is not possible because you have unmerged files.
hint: Fix them up in the work tree, and then use 'git add/rm <file>'
hint: as appropriate to mark resolution and make a commit.
fatal: Exiting because of an unresolved conflict.
```

Let's add first and then commit!

```console
git add test.txt
git commit -m 'Fix conflict'
git push
```

Now pull on computer 1 and check `test.txt`.

```console
git pull
cat test.txt
```
```
comp1
hi from both comps
comp2
```

## Scenario 3

Create a new branch on computer 1 and checkout.

```console
git branch edit
git checkout edit
```
```
Switched to branch 'edit'
```

Change `test.txt` to look like this:

```
comp1
hi from both computers
comp2
```

Add, commit, and push.

```console
git add test.txt
git commit -m 'No abbreviation'
git push
```
```
fatal: The current branch edit has no upstream branch.
To push the current branch and set the remote as upstream, use

    git push --set-upstream origin edit

To have this happen automatically for branches without a tracking
upstream, see 'push.autoSetupRemote' in 'git help config'.
```

Push as suggested.

```console
git push --set-upstream origin edit
```
```
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Writing objects: 100% (3/3), 280 bytes | 280.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
remote:
remote: To create a merge request for edit, visit:
remote:   http://192.168.0.42:8000/davetang/test_repo/-/merge_requests/new?merge_request%5Bsource_branch%5D=edit
remote:
To local:davetang/test_repo
 * [new branch]      edit -> edit
branch 'edit' set up to track 'origin/edit'.
```

Repeat this process on computer 2 with a new branch called `change` but change
`test.txt` to look like this:

```
comp1
hello from both comps
comp2
```

```console
git branch change
git checkout change
git add test.txt
git commit -m 'Hello instead of hi'
git push --set-upstream origin change
```
```
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Writing objects: 100% (3/3), 286 bytes | 286.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
remote:
remote: To create a merge request for change, visit:
remote:   http://192.168.0.42:8000/davetang/test_repo/-/merge_requests/new?merge_request%5Bsource_branch%5D=change
remote:
To local:davetang/test_repo
 * [new branch]      change -> change
branch 'change' set up to track 'origin/change'.
```

If we go to our GitLab page, we will now see three branches. Click on the
`change` branch and click on `Create merge request`. Leave all fields and
merge! You will see:

```
Changes merged into main with f4a38437.
Deleted the source branch.
```

and the `change` branch is automatically deleted.

Now click on the `edit` branch and create a new merge request as well. But you will see:

```
Merge blocked: 2 checks failed
Cannot merge the source into the target branch, due to a conflict.
Merge conflicts must be resolved.
```

There are two options "Resolve locally" or "Resolve conflicts". If we click on
"Resolve conflicts" we will see an editor and options to "Use ours" or "Use
theirs". Click "Use theirs" and "Commit to source branch". Then merge!

```
Merge details

Changes merged into main with ab3c6af8.
Deleted the source branch.
```

Only the `main` branch exists and `test.txt` looks like the change made on
computer 2:

```
comp1
hello from both comps
comp2
```
