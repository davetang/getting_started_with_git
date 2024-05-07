## Table of Contents

  - [Installation](#installation)
    - [Debian 12](#debian-12)
  - [Upgrading](#upgrading)
  - [Configuration](#configuration)
    - [GitLab Git LFS](#gitlab-git-lfs)
  - [User setup](#user-setup)
  - [Add remote](#add-remote)

## Installation

[Install](https://about.gitlab.com/install/) on various operating
systems/environments.

### Debian 12

Dependencies.

```console
sudo apt-get update \
    && sudo apt-get install -y curl openssh-server ca-certificates perl
```

Add the GitLab package repository and install the package.

```console
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
```

Install.

```console
sudo apt-get install -y gitlab-ee
```

[Configure](#configuration) and head over to the URL to see if everything is
working.

Use `root` and the password in `/etc/gitlab/initial_root_password` to login.
Then go to http://address:8000/-/user_settings/password/edit and change the
root password.

## Upgrading

[Upgrading](https://docs.gitlab.com/ee/update/package/) needs to be performed
step by step following an upgrade path. Use the [upgrade
path](https://gitlab-com.gitlab.io/support/toolbox/upgrade-path/) tool to
determine the appropriate path. It is important to [check for background
migrations before continuing with the upgrade
path](https://docs.gitlab.com/ee/update/background_migrations.html).

```bash
sudo gitlab-rails runner -e production 'puts Gitlab::BackgroundMigration.remaining'
sudo gitlab-rails runner -e production 'puts Gitlab::Database::BackgroundMigration::BatchedMigration.queued.count'
```

## Configuration

All
[configurations](https://docs.gitlab.com/omnibus/settings/configuration.html)
are set in a single configuration file located at

    /etc/gitlab/gitlab.rb

After modifying `/etc/gitlab/gitlab.rb`, run the following:

    sudo gitlab-ctl reconfigure

and after some time it should say "gitlab Reconfigured!"

If you have set up the hostname of your server in `/etc/hosts`, you can use it
in the config file:

    external_url 'http://hostname:8000'
    pages_external_url "http://hostname:8000/"
    gitlab_pages['enable'] = true

On Windows the Hosts file is in:

    C:\Windows\System32\drivers\etc

but you need to be admin to edit the file.

### GitLab Git LFS

See [LFS
administration](https://docs.gitlab.com/ee/administration/lfs/index.html).

Set the following in the config file to enable LFS.

```
gitlab_rails['lfs_enabled'] = true
gitlab_rails['lfs_storage_path'] = "/data/gitlab/gitlab-rails/shared/lfs-objects"
```

## User setup

1. Generate key and copy or move to `~/.ssh`

    ssh-keygen -t rsa -b 4096 -f local_gitlab

2. Add public key to http://address:8000/-/profile/keys)

3. Add entry to `~/.ssh/config`

```
Host local
 HostName address
 PreferredAuthentications publickey
 IdentityFile ~/.ssh/local_gitlab
```

4. Test

```console
ssh -T git@local
```
```
Welcome to GitLab, @davetang!
```

## Add remote

On GitLab make a new repository called `test_repo`.

```console
git init test_repo
cd test_repo/
echo hi > test.txt
git add test.txt
git commit -m 'Add test file'
git remote add origin git@local:davetang/test_repo.git
git push --set-upstream origin main
```

What if I created a repo locally first?

```console
mkdir first && cd first
git init
echo 1 > 1.txt
git add 1.txt
git commit -m 'First file'
```

Go to GitLab and:

1. Create a new project.
2. Create blank project
3. Fill in the Project URL
4. For the "Project Configuration" untick "Initialize repository with a README" because as suggested "Skip this if you plan to push up an existing repository."
5. Click create project
6. Push an existing repo

Note below that I created a repo with a different name on GitLab to illustrate that you do not need to use the same name as the folder.

```console
cd first
git remote add origin git@local:davetang/some_repo.git
git push --set-upstream origin main
```
```
Enumerating objects: 3, done.
Counting objects: 100% (3/3), done.
Writing objects: 100% (3/3), 216 bytes | 216.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
To local:davetang/some_repo.git
 * [new branch]      main -> main
branch 'main' set up to track 'origin/main'.
```
