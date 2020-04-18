#####################################################
#
#          Personal Environment Config
#            
#                     .--.
#           ::\`--._,'.::.`._.--'/::
#           ::::.  ` __::__ '  .::::
#           ::::::-:.`'..`'.:-::::::
#           ::::::::\ `--' /::::::::
#                     '--'
#
#                  Try not.
#         Do or do not. There is no try.
#####################################################


URL=https://github.com/meetshah1995/config.git
CONFIGDIR=$HOME/.mconfig

basic_update () {
    if [ ! -d "$CONFIGDIR" ] ; then
        echo "Config repo doesn't exist at $CONFIGDIR, cloning";
        git clone "$URL" "$CONFIGDIR";
    else
        echo "Config repo exists at $CONFIGDIR, checking for updates";
        cd "$CONFIGDIR";
        git pull "$URL";
    fi
}

dependencies () {
    # Install Vim 8.0
    sudo add-apt-repository --yes --force-yes ppa:jonathonf/vim
    sudo apt update --force-yes
    sudo apt-get install -y --no-install-recommends py3status \
                                                    i3 \
                                                    i3lock \
                                                    rofi \
                                                    vim
                                                    terminator\
                                                    ncdu \
                                                    tmux \
                                                    ranger \
                                                    w3m \
                                                    curl \
                                                    htop \
                                                    aria2 \
                                                    zsh \
                                                    fonts-font-awesome \
                                                    rxvt-unicode
    # Install python dependencies
    sudo python3 -m pip install sh \
                                neovim \
                                glances 
    echo "Dependencies installed";
}

# Setup git
git_update() {
    stow -v git
    echo "git updated";
}

# Setup zsh and oh-my-zsh
zsh_update() {
    whoami | xargs -n 1 sudo chsh -s $(which zsh) $1

    # install oh-my-zsh and powerline9k with fonts
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
    sudo mkdir -p /usr/share/fonts/truetype/fonts-iosveka/
    sudo cp $CONFIGDIR/static/iosveka-regular.ttf /usr/share/fonts/truetype/fonts-iosveka/

    # install zsh plugins
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions

    mv $HOME/.zshrc $HOME/.zshrc_old
    stow -v zsh
    echo "zsh updated";
}

# Setup vim and Vundle
vim_update() {
    # Clone and Install vim-plug
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim +silent +VimEnter +PluginInstall +qall
    echo "vim updated"; 
}

# Setup VS Code
vscode_update() {
    stow -v vscode
    echo "vscode updated";
}

# Setup tmux
tmux_update() {
    stow -v tmux
    git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
    tmux source-file $HOME/.tmux.conf
    echo "tmux updated";
}

# Setup terminator
terminator_update() {
    # Copy config to terminator
    stow -v terminator
    echo "terminator updated";
}

# Setup urxvt
urxvt_update() {
    stow -v urxvt
    xrdb $HOME/.Xdefaults
    echo "urxvt updated";
}

# Setup python modules
python_update() {
    stow -v python
    echo "python updated";
}

ranger_update() {
    stow -v ranger
    echo "ranger updated";
}

i3_update() {
    sudo add-apt-repository --force-yes ppa:jasonpleau/rofi
    sudo apt-get install -y --no-install-recommends py3status \
                                                    i3 \
                                                    i3lock \
                                                    rofi \
    stow -v i3
    echo "i3 updated";
}

binary_update() {
    for BIN in $CONFIGDIR/bin/*; do cp $BIN /usr/bin/$(basename $BIN) && chmod +x /usr/bin/$(basename $BIN); done
}

# Call all common update functions
common_update() {
    basic_update
    dependencies
    git_update
    python_update
    tmux_update
    ranger_update
    binary_update
}

# Call device specific functions
if [ "$1" = "server" ] ; then
    common_update
    vim_update

elif [ "$1" = "laptop" ] ; then
    common_update
    terminator_update
    vscode_update
    urxvt_update
    vim_update
    i3_update
else
    echo "Only laptop and server supported, $1 not supported"
fi
