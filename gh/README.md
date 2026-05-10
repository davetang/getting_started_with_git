# Useful `gh` CLI Commands

[`gh`](https://cli.github.com/) is GitHub's official command-line tool. It brings pull requests, issues, releases, and other GitHub concepts to the terminal next to where you're already working with `git`.

This README is a quick-reference cheat sheet of the commands I reach for most often.

## Setup

| Command | Description |
| --- | --- |
| `gh auth login` | Authenticate with GitHub (HTTPS or SSH, interactive prompts). |
| `gh auth status` | Show which account/host you're logged in as and the active token's scopes. |
| `gh auth refresh -s <scope>` | Add a new OAuth scope (e.g. `workflow`, `read:org`) to your existing token. |
| `gh auth logout` | Sign out from a host. |
| `gh config set editor <editor>` | Set the editor `gh` opens for PR/issue bodies (e.g. `vim`, `code --wait`). |
| `gh config set git_protocol ssh` | Use SSH instead of HTTPS for cloning via `gh`. |
| `gh extension install <owner/repo>` | Install a community `gh` extension. |
| `gh extension list` | List installed extensions. |

## Repositories

| Command | Description |
| --- | --- |
| `gh repo create [<name>]` | Create a new repository (interactive if no args; add `--public`/`--private`, `--source=.`, `--push`). |
| `gh repo clone <owner/repo>` | Clone a repo using your current auth. |
| `gh repo fork [<owner/repo>]` | Fork a repo; add `--clone` to clone the fork locally. |
| `gh repo view [<owner/repo>] --web` | Open the repo in your browser (omit `--web` to print the README in the terminal). |
| `gh repo list <owner>` | List repos for a user or org (supports `--limit`, `--visibility`, `--language`). |
| `gh repo set-default` | Set which remote `gh` uses when a repo has multiple. |
| `gh repo sync` | Sync a forked default branch with its upstream. |
| `gh repo archive <owner/repo>` | Archive a repository. |
| `gh repo delete <owner/repo>` | Delete a repository (requires confirmation; needs `delete_repo` scope). |

## Pull Requests

| Command | Description |
| --- | --- |
| `gh pr create` | Open a PR for the current branch (interactive; `--fill` reuses commit messages, `--draft` opens a draft). |
| `gh pr list` | List open PRs in the current repo (`--state all`, `--author @me`, `--label bug`, `--search "..."`). |
| `gh pr status` | Show PRs relevant to you: created, requested for review, current branch. |
| `gh pr view [<number>] --web` | View PR details (omit number to use the current branch; `--web` opens in browser). |
| `gh pr checkout <number>` | Check out the branch for a PR locally. |
| `gh pr diff [<number>]` | Show the PR diff in the terminal. |
| `gh pr checks [<number>]` | Show CI/check status for a PR; add `--watch` to follow live. |
| `gh pr review [<number>]` | Review a PR with `--approve`, `--request-changes`, or `--comment` plus `--body`. |
| `gh pr comment <number> -b "..."` | Add a comment to a PR. |
| `gh pr merge [<number>]` | Merge a PR; pick strategy with `--merge`, `--squash`, or `--rebase`, and `--delete-branch`. |
| `gh pr ready [<number>]` | Mark a draft PR as ready for review. |
| `gh pr close <number>` / `gh pr reopen <number>` | Close or reopen a PR. |

## Issues

| Command | Description |
| --- | --- |
| `gh issue create` | Create an issue (interactive; `--title`, `--body`, `--label`, `--assignee`, `--milestone`). |
| `gh issue list` | List issues (`--state`, `--label`, `--assignee @me`, `--search "..."`). |
| `gh issue status` | Show issues relevant to you. |
| `gh issue view <number> [--web]` | Show an issue with comments, or open it in the browser. |
| `gh issue comment <number> -b "..."` | Add a comment to an issue. |
| `gh issue edit <number>` | Edit fields like title, body, labels, assignees, milestone. |
| `gh issue close <number>` / `gh issue reopen <number>` | Close or reopen an issue. |
| `gh issue transfer <number> <repo>` | Move an issue to another repository. |

## GitHub Actions / Workflows

| Command | Description |
| --- | --- |
| `gh workflow list` | List workflows defined in the repo. |
| `gh workflow view <name-or-id>` | View a workflow's recent runs and YAML. |
| `gh workflow run <name-or-id>` | Manually trigger a `workflow_dispatch` workflow (`-f key=value` for inputs). |
| `gh workflow enable <name>` / `gh workflow disable <name>` | Enable/disable a workflow. |
| `gh run list` | List recent workflow runs (`--workflow`, `--branch`, `--user`). |
| `gh run view <run-id>` | Inspect a run; add `--log` for full logs, `--log-failed` for only failed step logs. |
| `gh run watch <run-id>` | Follow a run until it finishes. |
| `gh run rerun <run-id>` | Rerun a workflow; `--failed` reruns only failed jobs. |
| `gh run cancel <run-id>` | Cancel an in-progress run. |
| `gh run download <run-id>` | Download artifacts from a run. |

## Releases

| Command | Description |
| --- | --- |
| `gh release create <tag>` | Create a release (`--title`, `--notes`, `--generate-notes`, `--draft`, `--prerelease`, attach files at the end). |
| `gh release list` | List recent releases. |
| `gh release view <tag>` | Show a release's details and assets. |
| `gh release upload <tag> <files...>` | Attach files to an existing release (`--clobber` to overwrite). |
| `gh release download <tag>` | Download release assets (`--pattern '*.tar.gz'`). |
| `gh release delete <tag>` | Delete a release (the git tag is kept unless you add `--cleanup-tag`). |

## Gists

| Command | Description |
| --- | --- |
| `gh gist create <file>` | Create a gist from a file or stdin (`--public`, `--desc "..."`). |
| `gh gist list` | List your gists. |
| `gh gist view <id>` | View a gist; add `--web` to open in the browser. |
| `gh gist edit <id>` | Edit a gist in your editor. |
| `gh gist clone <id>` | Clone a gist as a git repository. |

## Search

| Command | Description |
| --- | --- |
| `gh search repos "<query>"` | Search repositories (`--language`, `--stars '>100'`, `--limit`). |
| `gh search issues "<query>"` | Search issues across GitHub. |
| `gh search prs "<query>"` | Search pull requests across GitHub. |
| `gh search code "<query>"` | Search code (requires authentication; respects search syntax). |
| `gh search commits "<query>"` | Search commits. |

## Power Tools

| Command | Description |
| --- | --- |
| `gh api <endpoint>` | Call any REST endpoint (e.g. `gh api repos/:owner/:repo/stargazers`). |
| `gh api graphql -f query='...'` | Run a GraphQL query; combine with `--paginate` and `-f var=value`. |
| `gh api --paginate <endpoint>` | Auto-follow pagination and concatenate JSON pages. |
| `gh api ... --jq '.[] .name'` | Filter JSON responses with `jq` syntax, no external `jq` needed. |
| `gh browse [<path>]` | Open the current repo (or a file/line) in the browser. |
| `gh status` | Cross-repo dashboard of mentions, review requests, and assigned issues. |
| `gh alias set co 'pr checkout'` | Create your own shortcut (then `gh co 123`). |
| `gh alias set bugs 'issue list --label=bug'` | Aliases can include flags and arguments. |
| `gh completion -s bash` | Print shell completion (also `zsh`, `fish`, `powershell`). |

## Handy Recipes

```bash
# Open the current branch's PR (or create one) in the browser
gh pr view --web || gh pr create --web

# Watch the latest workflow run on the current branch until it finishes
gh run watch "$(gh run list --branch "$(git branch --show-current)" --limit 1 --json databaseId --jq '.[0].databaseId')"

# Bulk-close stale issues labelled "wontfix"
gh issue list --label wontfix --state open --json number --jq '.[].number' \
  | xargs -I{} gh issue close {}

# List your own open PRs across every repo
gh search prs --author=@me --state=open

# Get a repo's default branch via the API
gh api repos/:owner/:repo --jq .default_branch
```

## References

- Manual: <https://cli.github.com/manual/>
- Source: <https://github.com/cli/cli>
- Run `gh help <command>` for full flag listings on any subcommand.
