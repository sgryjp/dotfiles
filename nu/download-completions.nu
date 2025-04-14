#!/usr/bin/env nu
use std log
let scripts_dir = $env.FILE_PWD | path join "custom-completions"
let base_url = "https://raw.githubusercontent.com/nushell/nu_scripts/main/custom-completions"
let targets = [
  "bat",
  "cargo",
  "curl",
  "docker",
  "dotnet",
  "git",
  "less",
  "man",
  "npm",
  "pnpm",
  "poetry",
  "pre-commit",
  "pytest",
  "rg",
  "rustup",
  "scoop",
  "ssh",
  "tar",
  "uv",
  "winget",
]

$targets | each {|it|
  cd $scripts_dir
  log info $"Downloading ($it)..."
  curl -fsSLO $"($base_url)/($it)/($it)-completions.nu"
}

null
