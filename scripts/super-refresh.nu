#!/usr/bin/env nu
use std log

def main [] {
  refresh-scoop
  refresh-pip
  refresh-npm
  refresh-pipx
  clean-tempfiles
  clean-dotcache
}

def refresh-scoop [] {
  if ((do { powershell scoop help } | complete | get exit_code) != 0) {
    log info "Skipping scoop recipe as `powershell scoop` failed."
  }
  powershell -Command {sooop update '*'}
  powershell -Command {scoop cleanup '*'}
  powershell -Command {scoop cache rm --all}
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

def clean-dotcache [] {
  let cache_dir = ($env | get -i "XDG_CACHE_HOME")
  if $cache_dir != null {
    let target = $cache_dir | path join '*'
    log info $"rm -rf ($target)"
    rm -rf $target
  }
}

def clean-tempfiles [] {
  let temp_dir = ($env | get -i "TEMP")
  if $temp_dir != null {
    let target = $temp_dir | path join '*'
    log info $"rm -rf ($target)"
    rm -rf $target
  }
}
