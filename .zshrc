# >>> Homebrew Environment Setup >>>
eval "$(/opt/homebrew/bin/brew shellenv)"
if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    autoload -Uz compinit
    compinit
fi
# <<< Homebrew Environment Setup <<<

# >>> Prompt Configuration >>>
# Using the more feature-rich PROMPT instead of PS1
PROMPT='%F{cyan}%n%f@%F{yellow}%m%f:%F{green}%~%f$ '
# <<< Prompt Configuration <<<

# >>> PATH Configuration >>>
# Add `~/bin` and TeX binaries to the `$PATH`
export PATH="$HOME/bin:/Library/TeX/texbin:$PATH"

# Load additional config files if they exist
for file in ~/.{path,exports,aliases,functions,extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file
# <<< PATH Configuration <<<

# >>> History Configuration >>>
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY    
setopt SHARE_HISTORY     
setopt HIST_IGNORE_DUPS  
setopt HIST_VERIFY       
# <<< History Configuration <<<

# >>> Directory and Shell Options >>>
# Directory navigation
setopt AUTO_CD          
setopt CORRECT         
setopt CORRECT_ALL     

# Globbing and pattern matching
setopt NO_CASE_GLOB     
setopt GLOBSTAR         

# Additional shell options
setopt AUTO_PUSHD           # Push directories to the stack
setopt PUSHD_IGNORE_DUPS    # Don't push duplicate directories
setopt PUSHD_SILENT         # Don't print directory stack
# <<< Directory and Shell Options <<<

# >>> Completion System Configuration >>>
autoload -Uz compinit
compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# SSH hostnames completion
_ssh_hosts() {
    local ssh_hosts
    if [ -e "$HOME/.ssh/config" ]; then
        ssh_hosts=(${(f)"$(grep "^Host " ~/.ssh/config | grep -v "[?*]" | awk '{for(i=2;i<=NF;i++) print $i}')"})
        _describe 'SSH hosts' ssh_hosts
    fi
}

# Register the completion function
zstyle ':completion:*:hosts' hosts
zstyle ':completion:*:(ssh|scp|sftp):*' tag-order hosts-domain,hosts-host,hosts-ipaddr
zstyle ':completion:*:(ssh|scp|sftp):*' group-order users hosts-domain hosts-host hosts-ipaddr
compdef _ssh_hosts ssh
compdef _ssh_hosts scp
compdef _ssh_hosts sftp

# Defaults and killall completion
compdef '_values "NSGlobalDomain options" "NSGlobalDomain"' defaults
compdef '_values "Common Applications" "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter"' killall
# <<< Completion System Configuration <<<

# >>> Conda Initialization >>>
__conda_setup="$('/Users/wjchang/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/wjchang/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/wjchang/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/wjchang/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< Conda Initialization <<<

# >>> Optional Enhancements >>>
# Uncomment if you want to use syntax highlighting and autosuggestions
# source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# <<< Optional Enhancements <<<

