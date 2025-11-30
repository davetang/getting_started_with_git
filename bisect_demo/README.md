# README

How to use `git bisect` to find a bad commit.

1. Change to the root directory of Git repo.
2. Check commit log:

```console
git log --oneline
```

3. Start bisecting:

```console
git bisect start
```

4. Mark the current commit (HEAD) as bad:

```console
git bisect bad
```

5. Mark the first commit as good (the initial calculator):

```console
git bisect good f41e92e
```
```
Bisecting: 2 revisions left to test after this (roughly 1 step)
[12a7ea9b05d457f66efbf050bb3ca81b352347e7] Add power function
```

Git will now check out a commit halfway through and ask you to test it:

```console
./bisect_demo/calculator.py
```
```
2 + 3 = 5
10 - 4 = 6
6 * 7 = 42
20 / 4 = 5.0
2 ^ 8 = 256
```

The output shows `2 + 3 = 5`; this commit is good:

```bash
git bisect good
```
```
Bisecting: 0 revisions left to test after this (roughly 1 step)
[2f651feac86c7e038df7e305898dbfe8dcb18ec6] Add square function
```

Test again.

```console
./bisect_demo/calculator.py
```
```
2 + 3 = -1
10 - 4 = 6
6 * 7 = 42
20 / 4 = 5.0
2 ^ 8 = 256
5 squared = 25
```

The output shows `2 + 3 = -1`; this commit is bad:

```console
git bisect bad
```
```
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[1b16d20e7c47c2e669addb70ba5a1708fb2799bc] Modify add function
```

Test again.

```console
./bisect_demo/calculator.py
```
```
2 + 3 = -1
10 - 4 = 6
6 * 7 = 42
20 / 4 = 5.0
2 ^ 8 = 256
5 squared = 25
```

Bad again; and now Git has found the first bad commit!

```console
git bisect bad
```
```
1b16d20e7c47c2e669addb70ba5a1708fb2799bc is the first bad commit
commit 1b16d20e7c47c2e669addb70ba5a1708fb2799bc
Author: Dave Tang <davetingpongtang@gmail.com>
Date:   Sun Nov 23 22:23:02 2025 +0900

    Modify add function

 bisect_demo/calculator.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
```

Show the change made by the commit.

```console
git show 1b16d20e7c47c2e669addb70ba5a1708fb2799bc
```
```
commit 1b16d20e7c47c2e669addb70ba5a1708fb2799bc (HEAD)
Author: Dave Tang <davetingpongtang@gmail.com>
Date:   Sun Nov 23 22:23:02 2025 +0900

    Modify add function

diff --git a/bisect_demo/calculator.py b/bisect_demo/calculator.py
index dc37aa0..884b14d 100755
--- a/bisect_demo/calculator.py
+++ b/bisect_demo/calculator.py
@@ -1,7 +1,7 @@
 #!/usr/bin/env python3

 def add(a, b):
-    return a + b
+    return a - b

 def subtract(a, b):
     return a - b
```

When you're done, exit bisect mode:

```console
git bisect reset
```

Remove the bad commit.

```console
git revert 1b16d20e7c47c2e669addb70ba5a1708fb2799bc
```

Correct output.

```console
/bisect_demo/calculator.py
```
```
2 + 3 = 5
10 - 4 = 6
6 * 7 = 42
20 / 4 = 5.0
2 ^ 8 = 256
5 squared = 25
3 cubed = 27
```
