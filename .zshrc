# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# >>> Homebrew Environment Setup >>>
if type brew &>/dev/null; then
    eval "$(brew shellenv)"
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi
# <<< Homebrew Environment Setup <<<

# >>> Oh My Zsh Configuration >>>
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

#check if zsh-autosuggestions and zsh-syntax-highlighting are installed
# Install oh-my-zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install common plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Install zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions || echo "Failed to install zsh-autosuggestions"
fi

# Install zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting || echo "Failed to install zsh-syntax-highlighting"
fi

# Oh My Zsh Plugins
plugins=(
    git
    web-search
    zsh-autosuggestions
    zsh-syntax-highlighting
)
# <<< Oh My Zsh Configuration <<<

# >>> History Configuration >>>
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY    
setopt SHARE_HISTORY     
setopt HIST_IGNORE_DUPS  
setopt HIST_VERIFY       
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
# <<< History Configuration <<<

# >>> Directory and Shell Options >>>
setopt AUTO_CD          
setopt CORRECT         
setopt CORRECT_ALL     
setopt NO_CASE_GLOB     
setopt GLOBSTAR         
setopt AUTO_PUSHD       
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT     
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

# >>> PATH Configuration >>>
export PATH="$HOME/bin:/Library/TeX/texbin:$PATH"

# Load additional config files
for file in ~/.{path,exports,aliases,functions,extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file
# <<< PATH Configuration <<<

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# >>> Key Bindings >>>
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
# <<< Key Bindings <<<

# >>> Conda Initialization >>> #this may vary
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

# >>> Powerlevel10k Configuration >>>
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# <<< Powerlevel10k Configuration <<<

