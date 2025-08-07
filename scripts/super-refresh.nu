#!/usr/bin/env nu
use std log

def main [] {
  refresh-scoop
  refresh-uv
  refresh-pip
  refresh-npm
  refresh-pipx
  clean-tempfiles
  clean-dotcache
}

def refresh-scoop [] {
  if ((which powershell | is-not-empty)
    and (do { powershell scoop help } | complete | get exit_code) != 0) {
    log info "scoop update --all"
    powershell -Command { sooop update --all }
    log info "scoop cleanup --all"
    powershell -Command { scoop cleanup --all }
    log info "scoop cache rm --all"
    powershell -Command { scoop cache rm --all }
  }
}

def refresh-npm [] {
  if (not (which npm | is-empty)) {
    log info "npm update --global"
    npm update --global
    log info "npm clean --force"
    npm cache clean --force
  }
}

def refresh-pip [] {
  if (not (which pip | is-empty)) {
    log info "pip cache purge"
    pip cache purge
  }
}

def refresh-pipx [] {
  if (not (which pipx | is-empty)) {
    log info "pipx upgrade-all"
    pipx upgrade-all
  }
}

def refresh-uv [] {
  if (not (which uv | is-empty)) {
    log info "uv tool upgrade --all"
    ^uv tool upgrade --all

    log info "uv cache prune"
    ^uv cache prune

    log info "uv self update"
    ^uv self update --quiet
  }
}

def clean-dotcache [] {
  let cache_dir = ($env | get -o "XDG_CACHE_HOME")
  if $cache_dir != null {
    let target = $cache_dir | path join '*'
    log info $"rm -rf ($target)"
    rm -rf $target
  }
}

def clean-tempfiles [] {
  let temp_dir = ($env | get -o "TEMP")
  if $temp_dir != null {
    let target = $temp_dir | path join '*'
    log info $"rm -rf ($target)"
    rm -rf $target
  }
}
