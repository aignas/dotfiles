extern crate clap;
use clap::App;
use clap::Arg;
use git2::Repository;

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

    let path = matches.value_of("PATH").unwrap();

    let output = get_output(path);
    debug!("Result: {:?}", output);
    print!("{} ", output.unwrap_or(String::new()))
}

fn get_output(path: &str) -> R<String> {
    let repo = Repository::discover(path).or(Err("no repo found"))?;
    Ok(format!("{} {}", branch_name(&repo)?, local_status(&repo)?))
}

fn branch_name(repo: &Repository) -> R<String> {
    let head = repo.head().or(Err("failed to get HEAD"))?;
    Ok(head.shorthand().unwrap_or("unknown").to_owned())
}

struct LocalStatus {
    staged: usize,
    unstaged: usize,
    untracked: usize,
    unmerged: usize,
}

impl LocalStatus {
    fn new() -> LocalStatus {
        LocalStatus {
            staged: 0,
            unstaged: 0,
            untracked: 0,
            unmerged: 0,
        }
    }

    fn is_empty(&self) -> bool {
        self.staged == 0 && self.unstaged == 0 && self.untracked == 0 && self.unmerged == 0
    }

    fn increment(&mut self, s: git2::Status) {
        if s.is_index_new()
            || s.is_index_modified()
            || s.is_index_deleted()
            || s.is_index_renamed()
            || s.is_index_typechange()
        {
            self.staged += 1
        }

        if s.is_wt_new() {
            self.untracked += 1
        }

        if s.is_wt_modified()
            || s.is_wt_deleted()
            || s.is_wt_typechange()
            || s.is_wt_renamed()
            || false
        {
            self.unstaged += 1
        }

        // if s.is_ignored(){ staged += 1 }

        if s.is_conflicted() {
            self.unmerged += 1
        }
    }
}

fn local_status(repo: &Repository) -> R<String> {
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
        Ok(String::from("✔"))
    } else {
        Ok(format!(
            "{}{}{}{}",
            non_zero("●", status.staged),
            non_zero("○", status.unstaged),
            non_zero("✗", status.unmerged),
            non_zero("+", status.untracked)
        ))
    }
}

fn non_zero(prefix: &str, i: usize) -> String {
    if i == 0 {
        String::new()
    } else {
        format!("{}{}", prefix, i)
    }
}
