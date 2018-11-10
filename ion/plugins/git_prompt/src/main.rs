extern crate clap;
use clap::App;
use clap::Arg;
use git2::Repository;

mod types;
use self::types::*;

#[macro_use]
extern crate log;
extern crate env_logger;

type R<T> = Result<T, String>;

fn main() {
    env_logger::init();
    let matches = App::new("git_prompt")
        .version("v0.1")
        .author("aignas@github")
        .about("Prints your git prompt info fast!")
        .arg(
            Arg::with_name("default_branch")
                .short("d")
                .long("default-branch")
                .help("default branch to use when printing diff status")
                .env("GIT_PROMPT_DEFAULT_BRANCH")
                .default_value("master"),
        )
        .arg(
            Arg::with_name("PATH")
                .help("Optional path to use for getting git info")
                .index(1)
                .default_value("."),
        )
        .get_matches();

    // Setting of this would clutter the CLI interface too much
    // TODO think of a way how to configure it nicely
    let cfg = Config {
        ok: '✔',
        staged: '●',
        unstaged: '○',
        unmerged: '✗',
        untracked: '+',
        ahead: '↑',
        behind: '↓',
        default_branch: matches.value_of("default_branch").unwrap().to_owned(),
    };

    let path = matches.value_of("PATH").unwrap();

    let output = get_output(path, &cfg);
    debug!("Result: {:?}", output);
    print!("{} ", output.unwrap_or(String::new()))
}

fn get_output(path: &str, cfg: &Config) -> R<String> {
    let repo = Repository::discover(path).or(Err("no repo found"))?;
    let branch = branch_name(&repo)?;
    let br_status = branch_status(&repo, &branch, cfg)?;
    let br_padding = if br_status.len() == 0 { "" } else { " " };
    let status = local_status(&repo, cfg)?;
    let st_padding = if status.len() == 0 { "" } else { " " };

    Ok(format!(
        "{branch}{br_padding}{br_status}{st_padding}{status}",
        branch = branch,
        br_padding = br_padding,
        br_status = br_status,
        st_padding = st_padding,
        status = status
    ))
}

fn branch_name(repo: &Repository) -> R<String> {
    let head = repo.head().or(Err("failed to get HEAD"))?;
    Ok(head.shorthand().unwrap_or("unknown").to_owned())
}

fn branch_status(repo: &Repository, name: &str, cfg: &Config) -> R<String> {
    let state = match repo.state() {
        git2::RepositoryState::Merge => Some("merge"),
        git2::RepositoryState::Rebase
        | git2::RepositoryState::RebaseInteractive
        | git2::RepositoryState::RebaseMerge => Some("rebase"),
        git2::RepositoryState::RevertSequence => Some("revert"),
        git2::RepositoryState::CherryPick | git2::RepositoryState::CherryPickSequence => {
            Some("cherry-pick")
        }
        _ => None,
    };

    if let Some(s) = state {
        return Ok(s.to_owned());
    }

    let name = get_remote_ref(repo, name).or_else(|_| get_remote_ref(repo, "master"))?;
    let ahead = non_zero(cfg.ahead, diff(repo, &name, "HEAD")?);
    let behind = non_zero(cfg.behind, diff(repo, "HEAD", &name)?);
    Ok(format!("{}{}", ahead, behind))
}

fn get_remote_ref(repo: &Repository, name: &str) -> R<String> {
    debug!("trying to get remote branch for {}", name);
    let br = repo
        .find_branch(name, git2::BranchType::Local)
        .or(Err("failed to get a local branch"))?;
    let upstream = br.upstream().or(Err("could not get upstream"))?;

    let reference = upstream.into_reference();
    reference
        .name()
        .ok_or("failed to get remote branch name".to_owned())
        .map(String::from)
}

fn diff(repo: &Repository, from: &str, to: &str) -> R<usize> {
    let mut revwalk = repo.revwalk().or(Err("failed to create revwalk"))?;
    revwalk
        .push_range(&format!("{}..{}", from, to))
        .or(Err("failed to push the commit range"))?;

    let c = revwalk.count();
    debug!("{} and {} diff is {}", from, to, c);
    Ok(c)
}

fn local_status(repo: &Repository, cfg: &Config) -> R<String> {
    let mut opts = git2::StatusOptions::new();
    opts.include_untracked(true)
        .recurse_untracked_dirs(false)
        .renames_head_to_index(true);

    let statuses = repo.statuses(Some(&mut opts)).or(Err("status failed"))?;

    let mut status = LocalStatus::new();
    for s in statuses.iter().map(|e| e.status()) {
        status.increment(s)
    }

    if status.is_empty() {
        Ok(cfg.ok.to_string())
    } else {
        Ok(format!(
            "{}{}{}{}",
            non_zero(cfg.staged, status.staged),
            non_zero(cfg.unstaged, status.unstaged),
            non_zero(cfg.unmerged, status.unmerged),
            non_zero(cfg.untracked, status.untracked)
        ))
    }
}

fn non_zero(prefix: char, i: usize) -> String {
    if i == 0 {
        String::new()
    } else {
        format!("{}{}", prefix, i)
    }
}
