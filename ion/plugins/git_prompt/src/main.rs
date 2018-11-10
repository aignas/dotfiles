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
            Arg::with_name("PATH")
                .help("Optional path to use for getting git info")
                .index(1)
                .default_value("."),
        )
        .get_matches();

    // Setting of this would clutter the CLI interface too much
    // TODO think of a way how to configure it nicely
    let status_chars = StatusChars {
        ok: '✔',
        staged: '●',
        unstaged: '○',
        unmerged: '✗',
        untracked: '+',
    };

    let path = matches.value_of("PATH").unwrap();

    let output = get_output(path, &status_chars);
    debug!("Result: {:?}", output);
    print!("{} ", output.unwrap_or(String::new()))
}

fn get_output(path: &str, status_chars: &StatusChars) -> R<String> {
    let repo = Repository::discover(path).or(Err("no repo found"))?;
    Ok(format!(
        "{} {}",
        branch_name(&repo)?,
        local_status(&repo, status_chars)?
    ))
}

fn branch_name(repo: &Repository) -> R<String> {
    let head = repo.head().or(Err("failed to get HEAD"))?;
    Ok(head.shorthand().unwrap_or("unknown").to_owned())
}

struct StatusChars {
    ok: char,
    staged: char,
    unstaged: char,
    unmerged: char,
    untracked: char,
}

fn local_status(repo: &Repository, chars: &StatusChars) -> R<String> {
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
        Ok(chars.ok.to_string())
    } else {
        Ok(format!(
            "{}{}{}{}",
            non_zero(chars.staged, status.staged),
            non_zero(chars.unstaged, status.unstaged),
            non_zero(chars.unmerged, status.unmerged),
            non_zero(chars.untracked, status.untracked)
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
