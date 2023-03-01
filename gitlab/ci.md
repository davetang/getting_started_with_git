# Getting started with GitLab CI/CD

This [quick start guide](https://docs.gitlab.com/ee/ci/quick_start/) provides a
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
* A test stage, with two jobs called test1 and test2.
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

# References

* [GitLab CI/CD Examples](https://docs.gitlab.com/ee/ci/examples/) including
  [templates](https://docs.gitlab.com/ee/ci/examples/#cicd-templates)
* [Predefined variables
  reference](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html)
* [Keyword reference for
  `.gitlab-ci.yml`](https://docs.gitlab.com/ee/ci/yaml/index.html)
