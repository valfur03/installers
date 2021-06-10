#!/bin/sh

set -eux;

sudo apt-get update
DEBIAN_FRONTEND=noninteractive \
	sudo apt-get -y install keyboard-configuration tzdata
DEBIAN_FRONTEND=noninteractive \
	sudo apt-get install -y --no-install-recommends clang curl docker.io \
													docker-compose gcc gdb git \
													libbsd-dev libsdl2-dev \
													libxext-dev libz-dev \
													lldb make python3 \
													python3-pip terminator vim \
													wget zsh 

# Install nodejs v14.x
curl -sL https://deb.nodesource.com/setup_14.x | sudo bash
sudo apt-get install -y --no-install-recommends nodejs

# Install oh-my-zsh
yes | sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Configure VIM
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
curl -o ~/.vimrc https://gist.githubusercontent.com/valfur03/f49e289c6f0b31c24fb167ec8fac461a/raw/.vimrc
vim +PluginInstall +qall
mkdir -p ~/.vim/plugin/ftdetect
echo 'au BufNewFile,BufRead *.c set cindent' >> ~/.vim/plugin/ftdetect/c.vim

# Configure zsh
curl -o ~/.zshrc https://gist.githubusercontent.com/valfur03/f49e289c6f0b31c24fb167ec8fac461a/raw/.zshrc
curl -o ~/.zsh_aliases https://gist.githubusercontent.com/valfur03/f49e289c6f0b31c24fb167ec8fac461a/raw/.zsh_aliases
curl -o ~/.oh-my-zsh/themes/custom.zsh-theme https://gist.githubusercontent.com/valfur03/f49e289c6f0b31c24fb167ec8fac461a/raw/custom.zsh-theme

set +u;
[ -z "$USER" ] && USER=root
set -u;

# Configure docker group
sudo usermod -aG docker $USER

# Change the shell
sudo sed -i '1iauth       sufficient   pam_wheel.so trust group=chsh' /etc/pam.d/chsh
sudo groupadd chsh
sudo usermod -aG chsh $USER
chsh -s $(which zsh)
sudo groupdel chsh
sudo sed -i '1d' /etc/pam.d/chsh

# Finish the installation
echo -e "\033[32mThe installation went well! You still need to reboot for some changes to take effect.\033[0m"
