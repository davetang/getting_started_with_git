# Getting started with GitLab CI/CD

The [quick start guide](https://docs.gitlab.com/ee/ci/quick_start/) provides a
nice overview on [GitLab CI/CD](https://docs.gitlab.com/ee/ci/).

The `.gitlab-ci.yml` file is a YAML file where you configure specific
instructions for GitLab CI/CD. In this file, you define:

* The structure and order of jobs that the runner should execute.
* The decisions the runner should make when specific conditions are
encountered.

## Pipelines

[Pipelines](https://docs.gitlab.com/ee/ci/pipelines/index.html) are the
top-level component of continuous integration, delivery, and deployment.
Pipelines comprise:

* Jobs, which define what to do. For example, jobs that compile or test code.
  Jobs are executed by runners.
* Stages, which define when to run the jobs. For example, stages that run tests
  after stages that compile the code.

A typical pipeline might consist of four stages, executed in the following order:

* A build stage, with a job called compile.
* A test stage, with two jobs called `test1` and `test2`.
* A staging stage, with a job called deploy-to-stage.
* A production stage, with a job called deploy-to-prod.

## Jobs

[Jobs](https://docs.gitlab.com/ee/ci/jobs/) are the most fundamental element of
a `.gitlab-ci.yml` file. Jobs are:

* Defined with constraints stating under what conditions they should be
  executed.
* Top-level elements with an arbitrary name and must contain at least the
  script clause.
* Not limited in how many can be defined.

Jobs are picked up by runners and **executed in the environment of the
runner**. What is important is that each job is run independently from each
other.

### Job control

Use `rules`, `only`, and `except` to control when a job runs. For example, I
have included an `only` rule that runs `test_only` only when this README file
is modified. Make sure to set the appropriate tag to set which runner to use.

```
test_only:
  tags:
    - runner_tag
  stage: test
  script:
    - echo "You modified README.md"
  only:
    changes:
      - README.md
```

## Example

[Bash.gitlab-ci.yml](https://gitlab.com/gitlab-org/gitlab/-/blob/master/lib/gitlab/ci/templates/Bash.gitlab-ci.yml).

```yml
# You can copy and paste this template into a new `.gitlab-ci.yml` file.
# You should not add this template to an existing `.gitlab-ci.yml` file by using the `include:` keyword.
#
# To contribute improvements to CI/CD templates, please follow the Development guide at:
# https://docs.gitlab.com/ee/development/cicd/templates.html
# This specific template is located at:
# https://gitlab.com/gitlab-org/gitlab/-/blob/master/lib/gitlab/ci/templates/Bash.gitlab-ci.yml

# See https://docs.gitlab.com/ee/ci/yaml/index.html for all available options

# you can delete this line if you're not using Docker
image: busybox:latest

before_script:
  - echo "Before script section"
  - echo "For example you might run an update here or install a build dependency"
  - echo "Or perhaps you might print out some debugging details"

after_script:
  - echo "After script section"
  - echo "For example you might do some cleanup here"

build1:
  stage: build
  script:
    - echo "Do your build here"

test1:
  stage: test
  script:
    - echo "Do a test here"
    - echo "For example run a test suite"

test2:
  stage: test
  script:
    - echo "Do another parallel test here"
    - echo "For example run a lint test"

deploy1:
  stage: deploy
  script:
    - echo "Do your deploy here"
  environment: production
```

See the [keyword reference
guide](https://docs.gitlab.com/ee/ci/yaml/index.html) for the full list of
configuration options for `.gitlab-ci.yml`.

Below are the keywords used in the example above.

* `image` - Use Docker images.
* `before_script` - Override a set of commands that are executed before job.
* `after_script` - Override a set of commands that are executed after job.
* `stage` - Defines a job stage. If stages is not defined in `.gitlab-ci.yml`,
the default pipeline stages are:
    * `.pre`
    * `build`
    * `test`
    * `deploy`
    * `.post`
* `script` - Shell script that is executed by a runner.
* `environment` - Name of an environment to which the job deploys. Common
environment names are `qa`, `staging`, and `production`, but you can use any name.

There are four jobs: `build1`, `test1`, `test2`, and `deploy1`. Each job
belongs to a stage (`build`, `test`, and `deploy`) and contains a script
section . The `stage` describes the sequential execution of jobs. If there are
runners available, jobs in a single stage run in parallel. Use the [needs
keyword](https://docs.gitlab.com/ee/ci/yaml/index.html#needs) to run jobs out
of stage order.

Additional configurations can be made to customise how your jobs and stages
perform:

* Use the [rules keyword](https://docs.gitlab.com/ee/ci/yaml/index.html#rules)
  to specify when to run or skip jobs.
* Keep information across jobs and stages persistent in a pipeline with
  [cache](https://docs.gitlab.com/ee/ci/yaml/index.html#cache) and
  [artifacts](https://docs.gitlab.com/ee/ci/yaml/index.html#artifacts).
* Use the [default
  keyword](https://docs.gitlab.com/ee/ci/yaml/index.html#default) to specify
  additional configurations that are applied to all jobs.

# References

* [GitLab CI/CD Examples](https://docs.gitlab.com/ee/ci/examples/) including
  [templates](https://docs.gitlab.com/ee/ci/examples/#cicd-templates)
* [Predefined variables
  reference](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html)
* [Keyword reference for
  `.gitlab-ci.yml`](https://docs.gitlab.com/ee/ci/yaml/index.html)
