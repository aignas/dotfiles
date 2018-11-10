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
    Ok(format!("{}", get_branch_name(&repo)?))
}

fn get_branch_name(repo: &Repository) -> R<String> {
    let head = repo.head().or(Err("failed to get HEAD"))?;
    Ok(head.shorthand().unwrap_or("unknown").to_owned())
}
