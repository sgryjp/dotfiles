# General coonfigurations
$env.EDITOR = "nvim"
$env.LESSCHARSET = "utf-8"

# Python (pip)
$env.PIP_REQUIRE_VIRTULENV = "true"

# Additional completion scripts
$env.NU_LIB_DIRS = [
    ($env.PWD | path join 'completions'),
]

# -----------------------------------------------------------------------------
# Prompt Customization
let use_nerd_font_icon = true
let prompt_icons = if $use_nerd_font_icon {{
  branch: "\u{f418} " # nf-oct-git_branch
  conflict: "\u{f421} " # nf-oct-alert
  staged: "+" # nf-oct-file_diff
  unstaged: "!"
  stash: "\u{f51e} " # nf-oct-stack
  merge_conflict: "\u{f47f} " # nf-oct-git_compare
}} else {{
  branch: ""
  conflict: "~"
  staged: "+"
  unstaged: "!"
  stash: "$"
  merge_conflict: ""
}}

# Create in-memory database table to store cached prompt string
def create_prompt_cache [] {
  if (stor open | schema | not ('_prompt_cache' in $in.tables)) {
    stor create -t _prompt_cache -c {
      version: int, timestamp: int, workdir: str, prompt: str
    }
    stor insert -t _prompt_cache -d {
      version: 1, timestamp: (1970-01-01 | into int), workdir: "", prompt: ""
    }
  }
}

# Load cached prompt string
def load_cached_prompt [] {
  stor open | query db 'SELECT * FROM _prompt_cache WHERE version = 1' | first
}

# Cache the specified prompt string
def cache_prompt [prompt: string] {
  stor update -t _prompt_cache -w 'version = 1' -u {
    timestamp: (date now | into int),
    workdir: $env.PWD,
    prompt: $prompt
  }

  $prompt
}

def create_last_error_segment [] {
    if ($env.LAST_EXIT_CODE != 0) {
      $"(ansi red)($env.LAST_EXIT_CODE)(ansi reset)"
    } else {
      ""
    }
}

def rename_repo_state [] {
  match $in {
    "clean" => "Clean",
    "merge" => "Merge",
    "revert" => "Revert",
    "revertsequence" => "RevertSequence",
    "cherrypick" => "CherryPick",
    "cherrypicksequence" => "CherryPickSequence",
    "bisect" => "Bisect",
    "rebase" => "Rebase",
    "rebaseinteractive" => $"RebaseInteractive",
    "rebasemerge" => "RebaseMerge",
    "applymailbox" => "ApplyMailbox",
    "applymailboxorrebase" => "ApplyMailboxOrRebase",
    _ => _,
  }
}

# Create prompt segment expressing Git repository information
def create_gstat_segment [] {
  let icons = $prompt_icons

  # Quit if gstat was not available.
  if (plugin list | where { $in.name == "gstat" } | is-empty) {
    return ""
  }

  # Use cached previous value if pwd not changed and time not elapsed.
  let cache = (load_cached_prompt)
  let current_dir = $env.PWD
  let current_time = (date now)
  if (
    $current_dir == $cache.workdir and
    $current_time - ($cache.timestamp | into datetime) < 1sec
  ) {
    return $cache.prompt
  }

  # Get stat of Git repository
  let stat = (gstat --no-tag $current_dir)
  if $stat.repo_name == "no_repository" {
    return ""
  }

  # Compose prompt string from the stat
  let branch = match $stat.branch {
    "" => "",
    _ => $"(ansi purple)($icons.branch)($stat.branch)(ansi reset)"
  }
  let behind_ahead = match ($stat.behind + $stat.ahead) {
    0 => "",
    _ => {
      let behind = match $stat.behind { 0 => "", _ => $"↓($stat.behind)" }
      let ahead = match $stat.ahead { 0 => "", _ => $"↑($stat.ahead)" }
      $"(ansi cyan)($behind + $ahead)(ansi reset)"
    }
  }
  let count_staged = $stat.idx_added_staged + $stat.idx_modified_staged + $stat.idx_deleted_staged;
  let count_staged = match $count_staged {
    0 => "",
    _ => $"(ansi green)($icons.staged)($count_staged)(ansi reset)",
  }
  let count_unstaged = $stat.wt_modified + $stat.wt_renamed + $stat.wt_deleted + $stat.wt_type_changed
  let count_unstaged = match $count_unstaged {
    0 => "",
    _ => $"(ansi yellow)!($count_unstaged)(ansi reset)",
  }
  let count_untracked = match $stat.wt_untracked { 0 => "", _ => $"?($stat.wt_untracked)"}
  let stashes = match $stat.stashes {
    0 => "",
    _ => $"(ansi default_dimmed)($icons.stash)($stat.stashes)(ansi reset)"
  }
  let count_conflicts = match $stat.conflicts {
    0 => "",
    _ => $"(ansi red)($icons.conflict)($stat.conflicts)(ansi reset)"
  }
  let state = match ($stat.state) {
    "clean" => "",
    _ => {
      $"(ansi yellow_reverse)($stat.state | rename_repo_state)(ansi reset)"
    },
  }
  let prompt = [
    $branch,
    $behind_ahead,
    $count_conflicts,
    $count_staged,
    $count_unstaged,
    $count_untracked,
    $stashes,
    $state,
  ] | where { $in | is-not-empty } | str join " "

  # Return the composed prompt string
  cache_prompt $prompt
}

# Setup prompt
create_prompt_cache
# $env.PROMPT_COMMAND = {|| ... }
$env.PROMPT_COMMAND_RIGHT = {||
  [(create_last_error_segment), (create_gstat_segment)] | str join " "
}
