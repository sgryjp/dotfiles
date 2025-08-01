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
  let branch = (ansi magenta) + $stat.branch + (ansi reset)
  let ahead_behind = match ($stat.ahead + $stat.behind) {
    0 => "",
    _ => {
      let ahead = match $stat.ahead { 0 => "", _ => $"↓($stat.ahead)" }
      let behind = match $stat.behind { 0 => "", _ => $"↑($stat.behind)" }
      $" (ansi black)($ahead + $behind)(ansi reset)"
    }
  }
  let prompt = $branch + $ahead_behind # + $conflicts + $state

  # Return the composed prompt string
  cache_prompt $prompt
}

# Setup prompt
create_prompt_cache
# $env.PROMPT_COMMAND = {|| ... }
$env.PROMPT_COMMAND_RIGHT = {||
  [(create_last_error_segment), (create_gstat_segment)] | str join " "
}
