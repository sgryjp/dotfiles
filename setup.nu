#!/usr/bin/env nu
use std log

let homedir = "~" | path expand

# ----------------------------------------------------------------------------
# Check prerequesties

# Ensure XDG_CONFIG_HOME is defined
if (not ('XDG_CONFIG_HOME' in $env)) {
  let default_config_home = $homedir | path join .config
  log warning $"Environment variable XDG_CONFIG_HOME is not set; falling back to ($default_config_home)"
  $env.XDG_CONFIG_HOME = $default_config_home
}
if (which ln | is-empty) {
  error make {
    msg: "External command `ln` is required. (Hint: You can install it by `scoop install uutils-coreutils`)"
  }
}

# ----------------------------------------------------------------------------
# Functions

def make_dir [path] {
  let path = $path | path expand
  log info $"mkdir ($path)"
  mkdir $path
}

# Make a symbolic link file at $link_name which points to $target.
def make_link [link_name, target] {
  # Make the target path absolute
  let link_name = $link_name | path expand -n
  let target = $target | path expand

  # Check safety
  if (not ($target | path exists)) {
    log error $"Link target does not exist: ($target)"
    return
  }
  if (($link_name | path expand) == $target) {
    log debug $"Skipped creating a symbolik link as it already exists: ($link_name)"
    return
  }

  # Create a symbolic link
  if ($link_name | path exists) {
    log info $"rm ($link_name)"
    rm $link_name
  }
  log info $"ln -s ($target) ($link_name)"
  do { ^ln -s $target $link_name }
  if ($env.LAST_EXIT_CODE != 0) {
    log error $"Failed to create a link `($link_name)`"
    return
  }
}

def append_line [line, path] {
  # Load all lines into an array
  let lines = open --raw $path | lines

  # Do nothing if the line is already inserted
  if ($lines | any {str contains $line}) {
    log debug ("Skip appending as the line already exists in the file " +
      $"({line: $line, path: $path})")
    return
  }

  # Insert the line
  log info $"Appending line... ({line: $line, path: $path})"
  $lines | append $line | save -f $path
}

# ----------------------------------------------------------------------------
# Main logic

# Nushell
append_line $"source ($env.FILE_PWD | path join nu env.nu)" ($env.FILE_PWD | path join $nu.env-path)
append_line $"source ($env.FILE_PWD | path join nu config.nu)" ($env.FILE_PWD | path join $nu.config-path)

# Wezterm
make_link ~/.wezterm.lua            ($env.FILE_PWD | path join wezterm.lua)

# Git
log info $"git config --global include.path ($env.FILE_PWD | path join git config)"
git config --global include.path ($env.FILE_PWD | path join git config)
log info $"cp ($env.FILE_PWD | path join git ignore) ($homedir | path join .gitignore)"
cp ($env.FILE_PWD | path join git ignore) ($homedir | path join .gitignore)

# VIM
make_dir ~/.vim/autoload
make_dir ~/.vim/colors
make_link ~/.vim/vimrc              ($env.FILE_PWD | path join vimfiles vimrc)
make_link ~/.vim/common.vim         ($env.FILE_PWD | path join vimfiles common.vim)
make_link ~/.vim/keymaps.vim        ($env.FILE_PWD | path join vimfiles keymaps.vim)
make_link ~/.vim/regular.vim        ($env.FILE_PWD | path join vimfiles regular.vim)
make_link ~/.vim/autoload/plug.vim  ($env.FILE_PWD | path join vimfiles autoload/plug.vim)

# Neovim
make_dir $"($env.XDG_CONFIG_HOME)/nvim/autoload"
make_dir $"($env.XDG_CONFIG_HOME)/nvim/lua/plugins"
make_link $"($env.XDG_CONFIG_HOME)/nvim/init.lua"          $"($env.FILE_PWD)/nvim/init.lua"
make_link $"($env.XDG_CONFIG_HOME)/nvim/lua/keymaps.lua"   $"($env.FILE_PWD)/nvim/lua/keymaps.lua"
make_link $"($env.XDG_CONFIG_HOME)/nvim/lua/options.lua"   $"($env.FILE_PWD)/nvim/lua/options.lua"
make_link $"($env.XDG_CONFIG_HOME)/nvim/autoload/plug.vim" $"($env.FILE_PWD)/vimfiles/autoload/plug.vim"
ls $"($env.FILE_PWD)/nvim/lua/plugins" | each {|ent|
  if ($ent.type == 'file') {
    let basename = $ent.name | path basename
    make_link $"($env.XDG_CONFIG_HOME)/nvim/lua/plugins/($basename)" $ent.name
  }
}

# Remove dead symlinks
ls ($"($env.XDG_CONFIG_HOME)/nvim/**/*" | into glob) | where {|it| $it.type == 'symlink'} | each {|file|
  let target = $file.name | path expand
  if (not ($target | path exists)) {
    log info $"rm ($file.name)"
    ^rm $file.name
  } else {
    log debug $"Confirmed ($file.name) is a living symlink to ($target)"
  }
}

return
