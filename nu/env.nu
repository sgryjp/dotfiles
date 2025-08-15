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

# Create prompt segment expressing Git repository information
def create_gstat_segment [] {
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
  let branch_icon = "\u{e725}" # nf-dev-git_branch
  let rebase_icon = "\u{e728}" # nf-dev-git_compare
  let conflict_icon = "\u{ea6c}" # nf-cod-warning
  let stash_icon = "\u{f51e}" # nf-oct-stack
  let branch = match $stat.branch {
    "" => "",
    _ => $"(ansi purple)($branch_icon) ($stat.branch)(ansi reset)"
  }
  let ahead_behind = match ($stat.ahead + $stat.behind) {
    0 => "",
    _ => {
      let ahead = match $stat.ahead { 0 => "", _ => $"↑($stat.ahead)" }
      let behind = match $stat.behind { 0 => "", _ => $"↓($stat.behind)" }
      $"(ansi cyan)($ahead + $behind)(ansi reset)"
    }
  }
  let count_staged = $stat.idx_added_staged + $stat.idx_modified_staged + $stat.idx_deleted_staged;
  let count_staged = match $count_staged {
    "" => "",
    _ => $"(ansi green)+($count_staged)(ansi reset)",
  }
  let count_unstaged = $stat.wt_modified + $stat.wt_renamed + $stat.wt_deleted + $stat.wt_type_changed
  let count_unstaged = match $count_unstaged {
    "" => "",
    _ => $"(ansi yellow)!($count_unstaged)(ansi reset)",
  }
  let count_untracked = match $stat.wt_untracked { 0 => "", _ => $"?($stat.wt_untracked)"}
  let stashes = match $stat.stashes {
    0 => "",
    _ => $"(ansi default_dimmed)($stash_icon) ($stat.stashes)(ansi reset)"
  }
  let count_conflicts = match $stat.conflicts {
    0 => "",
    _ => $"(ansi red)($conflict_icon) ($stat.conflicts)(ansi reset)"
  }
  let state = match ($stat.state) {
    "clean" => "",
    _ => {
      $"(ansi yellow_bold)($stat.state)(ansi reset)"
    },
  }
  let prompt = [
    $branch,
    $ahead_behind,
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
