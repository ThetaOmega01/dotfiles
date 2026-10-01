---
name: dotfiles
description: Manage the user's bare-repo dotfiles (`config` command, `~/.cfg`, GitHub ThetaOmega01/dotfiles). Use when installing dotfiles on a new computer, changing settings for one computer or all computers, committing or pushing dotfiles changes, syncing computer branches with `main`, or when the user mentions `config`, dotfiles, or `~/.cfg`.
---

# Dotfiles — `config`

[Git repository](https://github.com/ThetaOmega01/dotfiles)

## Agent notes

- `config` is a Fish function. In non-Fish shells it does not exist. Use the equivalent: `git --git-dir="$HOME/.cfg" --work-tree="$HOME" <args>`.
- `set shared_dir (mktemp -d ...)` is Fish syntax. In bash use `shared_dir=$(mktemp -d /tmp/dotfiles-main.XXXXXX)`.
- Run one command at a time. If a command fails, stop and report.
- Pushing to GitHub, merging, and branch changes affect remote or working files: perform them only when the user asked for them.

## Select the correct procedure

| Task | Procedure |
| --- | --- |
| Install the files on a new computer | A, then B |
| Change settings for one computer | C |
| Change settings for all computers | D, then E on each computer |
| Get the latest settings | E |

- `main` contains settings for all computers.
- Each computer uses a separate branch. This is its **computer branch**.
- A **commit** is a saved set of changes.
- `origin` is the GitHub repository.
- `$HOME` is your home directory. Git uses it as the **work tree**.

> **Protect the files**
> Make a backup before you change branches. Git can replace or remove files in `$HOME`.
> Use one command at a time. If a command fails, stop the procedure.
> Before a branch change or merge, save your changes in a commit.
> Use specified file paths with `config add`. Do not use `config add .` or `config add -A`.
> Do not add passwords or other secret data to Git.
> Do not merge a computer branch into `main`.

## Commit messages

Use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/): `<type>(<scope>): <description>`. The scope is optional.

- Use `feat` for a new feature, `fix` for a bug fix, `docs` for documentation, or `chore` for routine configuration and merges.
- Use a scope such as `ghostty`, `fish`, or `sync`. Describe the actual change, not just "change settings".
- Mark a breaking change with `!` before the colon, for example `chore(fish)!: remove legacy shell aliases`.

Replace the example messages below with descriptions of your changes.

## A. Install on a new computer

Install Git and Fish first. Use Fish for all commands. Do not do this procedure if `~/.cfg` already exists.

Source: [Atlassian installation procedure](https://www.atlassian.com/git/tutorials/dotfiles). These commands use Fish instead of Bash.

**1. Copy the repository.**
```fish
git clone --bare https://github.com/ThetaOmega01/dotfiles.git "$HOME/.cfg"
```

**2. Define the `config` command.** Enter the complete function.
```fish
function config --description 'Use the dotfiles repository' --wraps git
    command git --git-dir="$HOME/.cfg" --work-tree="$HOME" $argv
end
```

**3. Install the files in your home directory.**
```fish
config checkout
```
If Git reports that files would be replaced, move those files to a backup directory outside `$HOME`. Keep their directory structure. Then repeat `config checkout`. Do not use `--force`.

The repository excludes `.cfg`. It also contains the Fish function for subsequent sessions.

**4. Hide files that Git does not track.** You can still add a file by its path.
```fish
config config --local status.showUntrackedFiles no
```

**5. Get the branch references for procedures B to E.**
```fish
config config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
config fetch origin
```
Continue with B.

## B. Select a computer branch

On the new computer, replace `desktop` with its branch name.
```fish
config status
config fetch origin
```

**New branch:** create it from `main`, then send it to GitHub.
```fish
config switch --no-track -c desktop origin/main
config push -u origin desktop
```

**Branch already on GitHub:** use these commands instead of the two commands above. The copy from step A1 already created the local branch. The second command connects it to GitHub.
```fish
config switch desktop
config branch --set-upstream-to=origin/desktop
```

Keep this branch selected on this computer.

## C. Save changes for one computer

**1. Check the branch and changes.**
```fish
config branch --show-current
config diff
```

**2. Select the changed file.** Replace the example path as necessary.
```fish
config add .config/ghostty/config.ghostty
config diff --cached
```
To select only some changes in a file, use `config add -p path/to/file` instead of `config add`.

**3. Save the selected changes and send them to GitHub.**
```fish
config commit -m "chore(ghostty): update computer terminal settings"
config push
```

## D. Save changes for all computers

Make common changes on `main` in a temporary directory. Your home files stay on the computer branch. Procedure E then brings the changes to each computer, including this one.

**1. Open `main` in a temporary directory.**
```fish
config fetch origin
set shared_dir (mktemp -d /tmp/dotfiles-main.XXXXXX)
config worktree add "$shared_dir" main
git -C "$shared_dir" merge --ff-only origin/main
```
`$shared_dir` exists only in this Fish session. If you close Fish before step 3, run `config worktree list` to find the directory, then `set shared_dir /tmp/dotfiles-main.XXXXXX` with that path. macOS removes `/tmp` files on restart. If the directory is gone, run `config worktree prune`, then start again at step 1. Commits that you made in the directory stay on `main`.

**2. Change the files inside `$shared_dir`.** Do not include settings for one computer. Paths after `git -C "$shared_dir"` are relative to `$shared_dir`.
```fish
nvim "$shared_dir/.config/fish/config.fish"
git -C "$shared_dir" add .config/fish/config.fish
git -C "$shared_dir" diff --cached
git -C "$shared_dir" commit -m "chore(fish): update shared shell settings"
```
If you already made the change in `$HOME`, make the same change in `$shared_dir`. Then undo it in `$HOME` with `config restore path/to/file`. Procedure E brings it back.

**3. Send `main` to GitHub. Then remove the temporary directory.** Do not remove it if the push fails.
```fish
git -C "$shared_dir" push origin main
config worktree remove "$shared_dir"
```

Continue with E on each computer, including this one.

### If the push fails

GitHub has commits on `main` that you do not have. Add your commit after them, then repeat step 3:
```fish
git -C "$shared_dir" pull --rebase origin main
```

If the rebase has a conflict, correct the specified files **inside `$shared_dir`**. Then run:
```fish
git -C "$shared_dir" add path/to/resolved-file
git -C "$shared_dir" rebase --continue
```

To cancel the rebase instead, run:
```fish
git -C "$shared_dir" rebase --abort
```

### Cancel procedure D

Before step 3, this discards your changes in `$shared_dir`:
```fish
git -C "$shared_dir" reset --hard origin/main
config worktree remove "$shared_dir"
```

## E. Get the latest settings

Do this procedure on each computer. Keep its computer branch selected.

**1. Check for changes that you did not save.** Save them before you continue.
```fish
config status
```

**2. Get updates for this computer branch.**
```fish
config fetch origin
config pull --ff-only
```
If the pull fails because the branches have different commits, compare the local and GitHub histories. Do not use a force push.
```fish
config log --oneline --graph --decorate -15 HEAD '@{u}'
```
If the other commits are correct, combine the two histories. If Git opens a commit-message editor, replace the default message with `chore(sync): merge computer branch updates`. Then continue with step 3:
```fish
config pull --no-rebase --edit
config push
```
If this merge has a conflict, use "If the merge has a conflict" below.

**3. Add the common settings from `main`.**
```fish
config merge origin/main -m "chore(sync): merge shared settings"
config push
```

### If the merge has a conflict

Correct the specified files. Keep the settings necessary for this computer. Then run:
```fish
config add path/to/resolved-file
config commit -m "chore(sync): resolve settings merge"
config push
```

To cancel the merge instead, run:
```fish
config merge --abort
```

## Check the repository

| Command | Shows |
| --- | --- |
| `config branch --show-current` | Selected branch |
| `config status` | File status |
| `config diff` | Changes not selected for a commit |
| `config diff --cached` | Changes selected for a commit |
| `config log --oneline --graph --decorate -15` | Last 15 commits and branch references |

`config push` sends one branch to GitHub. It does not update other branches.
