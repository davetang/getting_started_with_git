# README

Practice resolving conflicts.

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

Now pull computer 1 and check `test.txt`.

```console
git pull
cat test.txt
```
```
comp1
hi from both comps
comp2
```
