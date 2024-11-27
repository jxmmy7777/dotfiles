#!/usr/bin/env zsh

cd "$(dirname "${(%):-%x}")";

# Install zsh if not present
if ! command -v zsh &> /dev/null; then
    if command -v apt &> /dev/null; then
        sudo apt install -y zsh
    elif command -v brew &> /dev/null; then
        brew install zsh
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y zsh
    fi
fi

git pull origin main;

function doIt() {
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude ".osx" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "LICENSE-MIT.txt" \
		--exclude ".zshrc" \
		-avh --no-perms . ~;
	
	if [ -f ~/.zshrc ]; then
		mv ~/.zshrc ~/.zshrc.backup
	fi
	
	cp .zshrc ~/.zshrc
	sed -i '' 's/setopt GLOBSTAR/#setopt GLOBSTAR/g' ~/.zshrc
	
	source ~/.zshrc;
}

if [[ "$1" == "--force" || "$1" == "-f" ]]; then
	doIt;
else
	read "REPLY?This may overwrite existing files in your home directory. Are you sure? (y/n) ";
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
