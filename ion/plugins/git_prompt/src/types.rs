pub struct LocalStatus {
    pub staged: usize,
    pub unstaged: usize,
    pub untracked: usize,
    pub unmerged: usize,
}

impl LocalStatus {
    pub fn new() -> LocalStatus {
        LocalStatus {
            staged: 0,
            unstaged: 0,
            untracked: 0,
            unmerged: 0,
        }
    }

    pub fn is_empty(&self) -> bool {
        self.staged == 0 && self.unstaged == 0 && self.untracked == 0 && self.unmerged == 0
    }

    pub fn increment(&mut self, s: git2::Status) {
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

pub struct Config {
    pub ok: char,
    pub staged: char,
    pub unstaged: char,
    pub unmerged: char,
    pub untracked: char,
    pub ahead: char,
    pub behind: char,

    pub default_branch: String,
}
