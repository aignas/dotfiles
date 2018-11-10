extern crate clap;
use clap::App;
use clap::Arg;
use git2::Repository;

mod fmt;
use self::fmt::*;
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
            Arg::with_name("test")
                .long("test")
                .help("print various combinations of the prompt"),
        )
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
        colors: &ColorScheme {
            branch: "yellow",
            branch_state: "red",
            ok: "bright green",
            staged: "bright green",
            unstaged: "yellow",
            merge: "bright red",
            untracked: "bright white",
            ahead: "green",
            behind: "red",

            rebase: "yellow",
            revert: "red",
            cherry_pick: "cyan",
        },
    };

    if matches.is_present("test") {
        print_all(&cfg);
        return;
    }

    let path = matches.value_of("PATH").unwrap();
    let output = get_output(path, &cfg);
    debug!("Result: {:?}", output);
    print!("{} ", output.unwrap_or(String::new()))
}

fn get_output(path: &str, cfg: &Config) -> R<String> {
    let repo = Repository::discover(path).or(Err("no repo found"))?;
    let branch = branch_name(&repo)?;
    let br_status = branch_status(&repo, &branch)?;
    let status = local_status(&repo)?;

    Ok(fmt_output(&branch, &br_status, &status, cfg))
}

fn branch_name(repo: &Repository) -> R<String> {
    let head = repo.head().or(Err("failed to get HEAD"))?;
    Ok(head.shorthand().unwrap_or("unknown").to_owned())
}

fn branch_status(repo: &Repository, name: &str) -> R<BranchStatus> {
    let s = match repo.state() {
        git2::RepositoryState::Merge => BranchState::OK,
        git2::RepositoryState::Rebase
        | git2::RepositoryState::RebaseInteractive
        | git2::RepositoryState::RebaseMerge => BranchState::Rebase,
        git2::RepositoryState::Revert | git2::RepositoryState::RevertSequence => {
            BranchState::Revert
        }
        git2::RepositoryState::CherryPick | git2::RepositoryState::CherryPickSequence => {
            BranchState::CherryPick
        }
        _ => BranchState::OK,
    };

    match s {
        BranchState::OK => Ok(BranchStatus {
            state: s,
            ..Default::default()
        }),
        _ => {
            let name = get_remote_ref(repo, name).or_else(|_| get_remote_ref(repo, "master"))?;
            Ok(BranchStatus {
                ahead: diff(repo, &name, "HEAD")?,
                behind: diff(repo, "HEAD", &name)?,
                ..Default::default()
            })
        }
    }
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

fn local_status(repo: &Repository) -> R<LocalStatus> {
    let mut opts = git2::StatusOptions::new();
    opts.include_untracked(true)
        .recurse_untracked_dirs(false)
        .renames_head_to_index(true);

    let statuses = repo.statuses(Some(&mut opts)).or(Err("status failed"))?;

    let mut status = LocalStatus::new();
    for s in statuses.iter().map(|e| e.status()) {
        status.increment(s)
    }
    Ok(status)
}
