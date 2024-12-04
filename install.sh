#!/bin/bash

# Install chezmoi if not present
if ! command -v chezmoi >/dev/null 2>&1; then
    sh -c "$(curl -fsLS get.chezmoi.io)"
fi

# Generate initial config
cat > ~/.config/chezmoi/chezmoi.toml <<EOL
[data]
    name = "$(git config --get user.name)"
    email = "$(git config --get user.email)"
    isWork = false
    isPersonal = true
    isMacOS = $([ "$(uname)" = "Darwin" ] && echo "true" || echo "false")
    isLinux = $([ "$(uname)" = "Linux" ] && echo "true" || echo "false")

[git]
    autoCommit = true
    autoPush = true

[edit]
    command = "code"
    args = ["--wait"]
EOL