#!/bin/bash

# *** Just a simple fancy console output ***
fancy_echo() {
    local fmt="$1"; shift

    # shellcheck disable=SC2059
    printf "\\n$fmt\\n" "$@"
}
# *** Append settings to my .zshrc profile file ***
append_to_zshrc() {
    local text="$1" zshrc
    local skip_new_line="${2:-0}"

    if [ -w "$HOME/.zshrc.local" ]; then
        zshrc="$HOME/.zshrc.local"
    else
        zshrc="$HOME/.zshrc"
    fi

    if ! grep -Fqs "$text" "$zshrc"; then
        if [ "$skip_new_line" -eq 1 ]; then
            printf "%s\\n" "$text" >> "$zshrc"
        else
            printf "\\n%s\\n" "$text" >> "$zshrc"
        fi
    fi
}

#
# - Install all the things with Homebrew, Casks and a Brewfile
#

# - If Homebrew is not installed
if ! which brew > /dev/null; then
    fancy_echo "Installing Homebrew..."
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi;

# - Update brew
fancy_echo "Updating brew..."
brew update

# - Install everything in Brewfile
# brew bundle Brewfile
fancy_echo "Installing dependencies from Brewfile..."
brew bundle install --verbose

# — Install RVM
fancy_echo "Configuring RVM as version manager for Ruby..."
\curl -L https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm | head -n 1

# — Install latest stable Ruby
fancy_echo "Installing latest stable Ruby..."
#rvm use ruby --install --default
rvm use ruby --install --latest
ruby -vs

# — Install and config Git
fancy_echo "Configuring git..."
git --version
git config --global user.name "Alejandro Ventura Contreras"
git config --global user.email "soyalexventura@gmail.com"
git config --global color.ui true
git config --global core.editor "vim"

# — Install Rails
fancy_echo "Installing Rails..."
gem install rails --no-document
rails --version

# - Manually install Node Version Manager `zsh-nvm` as Zsh plugin for installing, updating and loading NVM
fancy_echo "Installing ZSH-NVM plugin for oh-my-zsh..."
# Clone this repository somewhere (~/.zsh-nvm for example)
git clone https://github.com/lukechilds/zsh-nvm.git ~/.zsh-nvm
# Then source it in your .zshrc (or .bashrc)
source ~/.zsh-nvm/zsh-nvm.plugin.zsh
fancy_echo "Verifying NVM installation..."
command -v nvm
fancy_echo "Upgrading NVM installation..."
nvm upgrade

# - Install Node Version Manager OLD WAY
# fancy_echo "Installing NVM for mac..."
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
# fancy_echo "Verifying installation..."
# command -v nvm

# - Install NodeJs
fancy_echo "Installing NodeJs LTS version..."
# https://github.com/nvm-sh/nvm#long-term-support
nvm install --lts

# - Install Yarn
fancy_echo "Installing Yarn..."
brew install yarn

# - Install Prettier global
fancy_echo "Installing Prettier for vim-prettier plugin..."
#npm install --global prettier
yarn global add prettier

# - Setup custom Cobalt2 theme for oh-my-zsh
fancy_echo "Setting up theme for oh-my-zsh..."
cp zsh/themes/alexventuraio.zsh-theme ~/.oh-my-zsh/themes/alexventuraio.zsh-theme

# - Install fonts
fancy_echo "Installing fonts for iTerm..."
font_dir="$HOME/Library/Fonts"
cp "iTerm/InconsolataForPowerline.otf" "$font_dir/"
cp "iTerm/OperatorMono-Light.otf" "$font_dir/"
cp "iTerm/OperatorMono-Book.otf" "$font_dir/"
#cp "iTerm/OperatorMono-BookItalic.otf" "$font_dir/"
cp "iTerm/OperatorMono-Lig/OperatorMonoLig-Book.otf" "$font_dir/"
cp "iTerm/OperatorMono-Lig/OperatorMonoLig-BookItalic.otf" "$font_dir/"
cp "iTerm/OperatorMono-Lig/OperatorMonoLig-Light.otf" "$font_dir/"
cp "iTerm/OperatorMono-Lig/OperatorMonoLig-LightItalic.otf" "$font_dir/"

# - Install Vim plugin manager
fancy_echo "Installing Vim-Plug for unix..."
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# - Configure custom files for Janus vim
fancy_echo "Symlinking customization files for VIM..."
ln -sf ~/Dropbox/Code/dotfiles/vim/gvimrc ~/.gvimrc
ln -sf ~/Dropbox/Code/dotfiles/vim/vimrc ~/.vimrc

fancy_echo "Setting up Mac OS X development, done!!!!"
