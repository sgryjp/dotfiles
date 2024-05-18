# General coonfigurations
$env.EDITOR = nvim
$env.LESSCHARSET = "utf-8"
$env.PROMPT_COMMAND_RIGHT = ''

# Python (pip)
$env.PIP_REQUIRE_VIRTULENV = "true"

# Additional completion scripts
$env.NU_LIB_DIRS = [
    ($env.PWD | path join 'completions'),
]
