## GitLab Runner

The [GitLab Runner](https://docs.gitlab.com/runner/) is an application that
works with GitLab CI/CD to run jobs in a pipeline. It is recommended to install
GitLab Runner on another machine that is not hosting the GitLab instance for
security and performance reasons.

The GitLab Runner major.minor version should stay in sync with the GitLab
major.minor version for compatibility reasons.

There are [three ways](https://docs.gitlab.com/runner/install/) to install
GitLab Runner:

1. In a container
2. By downloading a binary manually
3. By using a repository for rpm/deb packages

Since GitLab Runner is a single executable (written in Go) with statically
linked libraries, it is easy to setup via manually downloading the binary. But
you may opt to use a package manager like `apt` or `yum`.

### Downloading a binary manually

Setting up a GitLab Runner by downloading a binary requires admin privileges.
When creating the `gitlab-runner` user, we have included the `docker` group so
that the Runner is able to use Docker (if we choose to use Docker as our
executor).

```bash
sudo curl -L --output /usr/local/bin/gitlab-runner "https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64"
sudo chmod +x /usr/local/bin/gitlab-runner
sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash --groups docker
sudo /usr/local/bin/gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
sudo /usr/local/bin/gitlab-runner start
```

When `gitlab-runner` runs as service, it will run as root, but will execute
jobs as user specified by the install command (`gitlab-runner`). This means
that some of the job functions like cache and artifacts will need to execute
`/usr/local/bin/gitlab-runner` command, therefore the user under which jobs are
run, needs to have access to the executable.

Next we need to [register a
runner](https://docs.gitlab.com/runner/register/index.html#linux).

* Enter the gitlab-ci coordinator URL
* Use the registration token from the Admin page
* Enter a description:
* Enter tags:
* Type shell as our executor

```bash
sudo /usr/local/bin/gitlab-runner register
```

Updating `gitlab-runner` to the latest version.

```bash
sudo /usr/local/bin/gitlab-runner stop
sudo curl -L --output /usr/local/bin/gitlab-runner "https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64"
sudo chmod +x /usr/local/bin/gitlab-runner
sudo /usr/local/bin/gitlab-runner start

sudo /usr/local/bin/gitlab-runner status
# Runtime platform                                    arch=amd64 os=linux pid=378904 revision=d540b510 version=15.9.1
# gitlab-runner: Service is running
```

### In a container

We can also install GitLab Runner [in a
container](https://docs.gitlab.com/runner/install/docker.html).

```bash
#!/usr/bin/env bash

set -euo pipefail

version=ubuntu-v15.9.1
image=gitlab/gitlab-runner:${version}
container_name=gitlab-runner

docker run \
  -d \
  --network="host" \
  --name $container_name \
  -v /srv/gitlab-runner/config:/etc/gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  ${image}

>&2 echo docker run --rm -it -v /srv/gitlab-runner/config:/etc/gitlab-runner ${image} register

exit 0
```

The directory `/srv/gitlab-runner/config` contains `config.toml`, which changes
the behaviour of the GitLab Runner; note that a GitLab Runner does not require
a restart when you change most options.

After starting the Runner, you need to register it on the GitLab page (you need
to be an admin) using a registration token.

We will use the following settings for registering a Runner with
[Docker](https://docs.gitlab.com/runner/executors/docker.html) and the
[Shell](https://docs.gitlab.com/runner/executors/shell.html) as our executors.

* Enter the gitlab-ci coordinator URL
* Use the registration token from the Admin page
* Enter a description:
* Enter tags:
* Type shell as our executor
* Default Docker image: ruby:2.7

Now we start the registration process and enter the details as per above.

```bash
version=ubuntu-v15.9.1
docker run --rm -it -v /srv/gitlab-runner/config:/etc/gitlab-runner gitlab/gitlab-runner:${version} register
```

If you need to make manual changes, log into the running instance as `root`.

```bash
docker exec -it gitlab-runner /bin/bash
```

Finally, in the Admin page of GitLab, check/tick `Run untagged jobs` and
uncheck/untick `Lock to current projects`.

Note that the general rule is that every GitLab Runner command that normally
would be executed as:

```bash
gitlab-runner <runner command and options...>
```

The equivalent using Docker is as:

```bash
docker run <chosen docker options...> gitlab/gitlab-runner <runner command and options...>
```

For a GitLab instance that is running inside a Docker container, include the
following settings:

* Add `network_mode = "host"` to the
  [runners.docker](https://docs.gitlab.com/runner/configuration/advanced-configuration.html#the-runnersdocker-section)
  section in `/srv/gitlab-runner/config/config.toml`.

```
concurrent = 1
check_interval = 0

[session_server]
  session_timeout = 1800

[[runners]]
  name = "shared"
  url = "http://ipaddr:8000/"
  token = ""
  executor = "docker"
  [runners.custom_build_dir]
  [runners.cache]
    [runners.cache.s3]
    [runners.cache.gcs]
  [runners.docker]
    tls_verify = false
    image = "ruby:2.7"
    privileged = false
    disable_entrypoint_overwrite = false
    oom_kill_disable = false
    disable_cache = false
    volumes = ["/cache"]
    shm_size = 0
    network_mode = "host"
```
