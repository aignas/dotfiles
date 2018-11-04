use colored::*;
use git2::Repository;
use std::env;

type MaybePrompt = Option<String>;
type Prompt = String;

fn main() {
    let path = env::var("PWD")
        .unwrap_or(String::new());
    print!("{} ", get_prompt(&path))
}

/// Returns the prompt with the git repository information at the given path
fn get_prompt(path: &str) -> Prompt {
    if let Some(i) = get_maybe_prompt(path) {
        format!("{} {}{}{} {}",
                i.revision.white(),
                i.behind.white(),
                i.ahead.white(),
                i.status,
                i.state)
    } else {
        String::new()
    }
}

#[cfg(test)]
mod get_prompt_tests {
    use super::get_prompt;
    use std::env;

    macro_rules! invalid_input_tests {
        ($($name:ident: $value:expr,)*) => {
        $(
            #[test]
            fn $name() {
                let (input, expected) = $value;
                assert_eq!(expected, get_prompt(input));
            }
        ) *
        }
    }

    invalid_input_tests! {
        empty_for_root: ("/", ""),
        empty_for_usr_local_bin: ("/usr/local/bin", ""),
        empty_for_non_existant_path: ("/tmp/i/do/not/exist", ""),
    }

    #[test]
    fn non_empty_for_pwd() {
        let path = env::var("PWD")
            .unwrap_or(String::new());
        assert_ne!(get_prompt(&path), "");
    }
}

fn get_maybe_prompt(path: &str) -> Option<PromptInfo> {
    let repo = Repository::discover(path).ok()?;

    Some(PromptInfo{
        revision: get_branch(&repo)
            .unwrap_or(get_sha(&repo)[..8].to_string()),
        behind: behind_count(&repo)?,
        ahead: ahead_count(&repo)?,
        status: status(&repo).unwrap_or(String::new()),
        state: state(&repo),
    })
}

struct PromptInfo {
    revision: String,
    behind: String,
    ahead: String,
    status: String,
    state: String,
}

fn get_branch(repo: &git2::Repository) -> MaybePrompt {
    let shorthand = repo.head()
        .ok()
        .as_ref()
        .and_then(|h| h.shorthand().map(String::from));

    if Some(String::from("HEAD")) == shorthand {
        None
    } else {
        shorthand
    }
}

fn get_sha(repo: &git2::Repository) -> Prompt {
    repo.head()
        .ok()
        .map(|h| h.target().map(|t| t.to_string()))
        .unwrap_or(None)
        .unwrap_or(String::new())
}

fn ahead_count(repo: &git2::Repository) -> MaybePrompt {
    let rev = format!("origin/{}", get_branch(repo)?);
    Some(non_zero("↑", count_between(repo, &rev, "HEAD")))
}

fn behind_count(repo: &git2::Repository) -> MaybePrompt {
    let rev = format!("origin/{}", get_branch(repo)?);
    Some(non_zero("↓", count_between(repo, "HEAD", &rev)))
}

fn count_between(repo: &git2::Repository, from: &str, to: &str) -> usize {
    if let Ok(mut revwalk) = repo.revwalk() {
        if revwalk.push_range(&format!("{}..{}", from, to)).is_ok() {
            return revwalk.count();
        }
    }
    0
}

fn status(repo: &git2::Repository) -> MaybePrompt {
    let mut opts = git2::StatusOptions::new();
    opts.include_untracked(false);
    opts.exclude_submodules(true);

    let statuses = repo.statuses(Some(&mut opts)).ok()?;
    let mut changes: usize = 0;
    let mut staged: usize = 0;
    let mut conflicts: usize = 0;
    for entry in statuses.iter().filter(|e| e.status() != git2::Status::CURRENT) {
        let s = entry.status();
        // NOTE: a single entry might belong to multiple categories
        if is_index_change(&s)    {staged += 1}
        if is_worktree_change(&s) {changes += 1}
        if s.is_conflicted()      {conflicts += 1}
    }

    if changes == 0 && staged == 0 && conflicts == 0 {
         Some(format!("{}", "✔".green()))
    } else {
        Some(format!("{}{}{}",
             non_zero("•", staged).green(),
             non_zero("✖", conflicts).red(),
             non_zero("+", changes).yellow()))
    }
}

fn is_index_change(s: &git2::Status) -> bool {
    s.is_index_deleted() ||
        s.is_index_modified() ||
        s.is_index_new() ||
        s.is_index_renamed() ||
        s.is_index_typechange()
}

fn is_worktree_change(s: &git2::Status) -> bool {
    s.is_wt_deleted() ||
        s.is_wt_modified() ||
        s.is_wt_new() ||
        s.is_wt_renamed() ||
        s.is_wt_typechange()
}

fn non_zero(prefix: &str, number: usize) -> String {
    if number == 0 {
        String::new()
    } else {
        format!("{}{}", prefix, number)
    }
}

// https://docs.rs/git2/0.7.5/git2/enum.RepositoryState.html
fn state(repo: &git2::Repository) -> Prompt {
    match repo.state() {
        git2::RepositoryState::Merge => format!("{}", "merge".red()),
        git2::RepositoryState::Rebase => format!("{}", "rebase".yellow()),
        git2::RepositoryState::RebaseInteractive => format!("{}", "rebase".yellow()),
        _ => String::new()
    }
}
