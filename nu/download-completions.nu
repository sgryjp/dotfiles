use std log
let scripts_dir = $env.FILE_PWD | path join "custom-completions"
let base_url = "https://raw.githubusercontent.com/nushell/nu_scripts/main/custom-completions"
let targets = [ "bat", "cargo", "curl", "git", "npm", "poetry", "rg", "rustup" ]

$targets | each {|it|
  cd $scripts_dir
  log info $"Downloading ($it)..."
  curl -fsSLO $"($base_url)/($it)/($it)-completions.nu"
}

null
