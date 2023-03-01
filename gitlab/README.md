Table of Contents
=================

   * [README](#readme)
      * [Installation](#installation)
      * [Upgrading](#upgrading)
      * [Configuration](#configuration)
         * [GitLab Git LFS](#gitlab-git-lfs)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

## README

Notes for a self-managed GitLab instance.

### Installation

[Install](https://about.gitlab.com/install/) on various operating
systems/environments.

### Upgrading

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

### Configuration

Configuration is via `/etc/gitlab/gitlab.rb`.

If you have set up the hostname of your server in `/etc/hosts`, you can use it
in the config file:

    external_url 'http://hostname:8000'
    pages_external_url "http://hostname:8000/"

On Windows the Hosts file is in:

    C:\Windows\System32\drivers\etc

but you need to be admin to edit the file.

#### GitLab Git LFS

See [LFS
administration](https://docs.gitlab.com/ee/administration/lfs/index.html).

Set the following in the config file to enable LFS.

```
gitlab_rails['lfs_enabled'] = true
gitlab_rails['lfs_storage_path'] = "/data/gitlab/gitlab-rails/shared/lfs-objects"
```
