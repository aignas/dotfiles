use git2::Repository;
extern crate clap;
use clap::App;
use clap::Arg;

type R<T> = Result<T, String>;

fn main() {
    let matches = App::new("git_prompt")
        .version("v0.1")
        .author("aignas@github")
        .about("Prints your git prompt info fast!")
        .arg(
            Arg::with_name("diagnostic")
                .short("d")
                .long("debug")
                .help("print all errors and the result"),
        )
        .arg(
            Arg::with_name("PATH")
                .help("Optional path to use for getting git info")
                .index(1)
                .default_value("."),
        )
        .get_matches();

    let path = matches.value_of("PATH").unwrap();
    let debug = matches.is_present("diagnostic");

    let result = get_branch_name_d(path, debug);
    if debug {
        println!("Result: {:?}", result)
    } else {
        print!("{} ", result)
    }
}

fn get_branch_name_d(path: &str, debug: bool) -> String {
    match get_branch_name(path) {
        Ok(b) => b,
        Err(msg) => {
            if debug {
                println!("ERROR: {}", msg);
            }
            String::new()
        }
    }
}

fn get_branch_name(path: &str) -> R<String> {
    let repo = Repository::discover(path).or(Err("failed to find a repo for the given path"))?;
    let head = repo.head().or(Err("failed to get HEAD"))?;

    Ok(head.shorthand().unwrap_or("unknown").to_owned())
}
