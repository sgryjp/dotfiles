[
    "https://raw.githubusercontent.com/nushell/nu_scripts/main/custom-completions/bat/bat-completions.nu"
    "https://raw.githubusercontent.com/nushell/nu_scripts/main/custom-completions/cargo/cargo-completions.nu"
    "https://raw.githubusercontent.com/nushell/nu_scripts/main/custom-completions/curl/curl-completions.nu"
    "https://raw.githubusercontent.com/nushell/nu_scripts/main/custom-completions/git/git-completions.nu"
    "https://raw.githubusercontent.com/nushell/nu_scripts/main/custom-completions/npm/npm-completions.nu"
    "https://raw.githubusercontent.com/nushell/nu_scripts/main/custom-completions/poetry/poetry-completions.nu"
    "https://raw.githubusercontent.com/nushell/nu_scripts/main/custom-completions/rg/rg-completions.nu"
    "https://raw.githubusercontent.com/nushell/nu_scripts/main/custom-completions/rustup/rustup-completions.nu"
] |
    each {|it| cd ([$env.FILE_PWD, "custom-completions"] | path join) ; curl -fsSLO $it }

