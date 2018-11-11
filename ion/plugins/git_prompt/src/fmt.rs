extern crate colored;
use colored::*;
extern crate rand;
use rand::Rng;

use super::types::*;

pub fn fmt_output(
    branch: &str,
    br_status: &BranchStatus,
    status: &LocalStatus,
    cfg: &Config,
) -> String {
    format!(
        "{branch}{br_padding}{br_state}{ahead}{behind} {status}",
        branch = branch.color(cfg.colors.branch),
        br_padding = if !br_status.clean() { " " } else { "" },
        br_state = br_status.state.fmt(cfg),
        ahead = non_zero_color(cfg.ahead, br_status.ahead, cfg.colors.ahead),
        behind = non_zero_color(cfg.behind, br_status.behind, cfg.colors.behind),
        status = if status.is_ok() {
            format!("{}", cfg.ok.to_string().color(cfg.colors.ok))
        } else {
            format!(
                "{}{}{}{}",
                non_zero_color(cfg.staged, status.staged, cfg.colors.staged),
                non_zero_color(cfg.unstaged, status.unstaged, cfg.colors.unstaged),
                non_zero_color(cfg.unmerged, status.unmerged, cfg.colors.merge),
                non_zero_color(cfg.untracked, status.untracked, cfg.colors.untracked)
            )
        }
    )
}

impl BranchState {
    fn fmt(&self, cfg: &Config) -> String {
        match self {
            BranchState::OK => String::new(),
            BranchState::Merge => format!("{}", "merge".color(cfg.colors.merge)),
            BranchState::Rebase => format!("{}", "rebase".color(cfg.colors.rebase)),
            BranchState::Revert => format!("{}", "revert".color(cfg.colors.revert)),
            BranchState::CherryPick => format!("{}", "cherry-pick".color(cfg.colors.cherry_pick)),
        }
    }
}

fn non_zero(prefix: char, i: usize) -> String {
    if i == 0 {
        String::new()
    } else {
        format!("{}{}", prefix, i)
    }
}

fn non_zero_color(prefix: char, i: usize, c: &str) -> String {
    if i == 0 {
        String::new()
    } else {
        format!("{}{}", prefix.to_string().color(c), i)
    }
}

pub fn print_all(cfg: &Config) {
    let branches = vec!["master", "develop", "feature/foo"];
    let states = vec![
        BranchState::OK,
        BranchState::Merge,
        BranchState::Rebase,
        BranchState::Revert,
        BranchState::CherryPick,
    ];
    let values: Vec<usize> = (1..11).collect();

    let mut rng = rand::thread_rng();

    for _ in 0..15 {
        let branch = *rng.choose(&branches).unwrap();
        let br_status = gen_br_status(&mut rng, &states, &values);
        let status = gen_status(&mut rng, &values);
        println!("{}", fmt_output(branch, &br_status, &status, cfg))
    }
}

fn gen_status<T: rand::Rng>(rng: &mut T, collection: &Vec<usize>) -> LocalStatus {
    LocalStatus {
        staged: choose(rng, collection, 0.25),
        unstaged: choose(rng, collection, 0.25),
        unmerged: choose(rng, collection, 0.25),
        untracked: choose(rng, collection, 0.25),
    }
}

fn gen_br_status<T: rand::Rng>(
    rng: &mut T,
    states: &Vec<BranchState>,
    collection: &Vec<usize>,
) -> BranchStatus {
    if rng.gen_bool(0.5) {
        BranchStatus {
            state: *rng.choose(&states).unwrap(),
            ..Default::default()
        }
    } else {
        BranchStatus {
            ahead: choose(rng, collection, 0.5),
            behind: choose(rng, collection, 0.5),
            ..Default::default()
        }
    }
}

fn choose<T: rand::Rng>(rng: &mut T, collection: &Vec<usize>, prob: f64) -> usize {
    if rng.gen_bool(prob) {
        *rng.choose(&collection).unwrap()
    } else {
        0
    }
}
