# General coonfigurations
$env.EDITOR = "nvim"
$env.LESSCHARSET = "utf-8"

# Python (pip)
$env.PIP_REQUIRE_VIRTULENV = "true"

# Additional completion scripts
$env.NU_LIB_DIRS = [
    ($env.PWD | path join 'completions'),
]

# Customize Prompt
def create_left_prompt [] {
    # Copy & pated code from the default implementation
    let dir = match (do --ignore-shell-errors { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)(ansi reset)"

    # Original part
    let last_error = (
        if ($env.LAST_EXIT_CODE != 0) { $"(ansi red)[($env.LAST_EXIT_CODE)](ansi reset) " } else { "" }
    )

    $"($last_error)($path_segment)" |
        str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}
$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = ''
