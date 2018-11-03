use colored::*;
use git2::Repository;
use std::env;

type MaybePrompt = Option<String>;
type Prompt = String;

fn main() {
    if let Ok(dir) = env::var("PWD") {
      print!("{} ", get_prompt(&dir).unwrap_or(String::new()))
    } else {
      print!(" ")
    }
}

fn get_prompt(path: &str) -> MaybePrompt {
    let repo = Repository::discover(path).ok()?;

    let rev = get_branch(&repo)?.white();
    let behind = behind_count(&repo).white();
    let ahead = ahead_count(&repo).white();
    let status = status(&repo).unwrap_or(String::new());
    let state = state(&repo);

    Some(format!("{} {}{}{} {}", rev, behind, ahead, status, state))
}
fn get_branch(repo: &git2::Repository) -> MaybePrompt {
    let head = match repo.head() {
        Ok(head) => Some(head),
        Err(ref e) if e.code() == git2::ErrorCode::UnbornBranch ||
                      e.code() == git2::ErrorCode::NotFound => None,
        Err(e) => {
            println!("{}", e);
            return None
        }
    };
    head.as_ref()
        .and_then(|h| h.shorthand())
        .map(|rev| if rev == "HEAD" {
             get_sha(repo)
        }else {
            String::from(rev)
        })
}

fn get_sha(repo: &git2::Repository) -> Prompt {
    let string = repo.head()
        .ok()
        .map(|h| h.target().map(|t| t.to_string()))
        .unwrap_or(None)
        .unwrap_or(String::new());

    String::from(&string[..8])
}

fn ahead_count(repo: &git2::Repository) -> Prompt {
    non_zero("↑", count_between(repo, "origin/master", "HEAD"))
}

fn behind_count(repo: &git2::Repository) -> Prompt {
    non_zero("↓", count_between(repo, "HEAD", "origin/master"))
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
    let mut staged: usize = 0;
    let mut untracked: usize = 0;
    let mut merge: usize = 0;
    for entry in statuses.iter().filter(|e| e.status() != git2::Status::CURRENT) {
        match entry.status() {
            // TODO: finish the status
            s if s.is_wt_new() => untracked += 1,
            s if s.is_index_modified() => staged+=1,
            s if s.is_conflicted() => merge+=1,
            _ => (),
        };
    }

    if staged == 0 && untracked == 0 && merge == 0 {
         Some(format!("{}", "✔".green()))
    } else {
        Some(format!("{}{}{}",
             non_zero("●", staged).green(),
             non_zero("✖", merge).red(),
             non_zero("✚", untracked).white()))
    }
}

fn non_zero(prefix: &str, number: usize) -> String {
    if number == 0 {
        String::new()
    }else {
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
