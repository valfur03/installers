#!/bin/sh

NC="\033[0m"
BOLD="\033[1m"
ULINE="\033[4m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"

# Options
# 
# g, gnome -> Gnome
# k, kde-plasma -> KDE
# x, xfce -> xfce

print_usage()
{
	exec 1>&2
	printf "Usage: %s [-gkx]\n" $(basename "$0")
	exit 1
}

DESKTOP=""
set_desktop()
{
	if [ -z $DESKTOP ]
	then
		DESKTOP=$1
	else
		echo "Desktop environment already set to '$DESKTOP'" 1>&2
		exit 1
	fi
}

while getopts ":gkx" opt
do
	case $opt in
	g|gnome)
		set_desktop "gnome"
		;;
	k|kde-plasme)
		set_desktop "kde-plasma"
		;;
	x|xfce)
		set_desktop "xfce"
		;;
	\?)
		echo "Invalid Option: -$OPTARG" 1>&2
		print_usage
		;;
	:)
		echo "Invalid Option: -$OPTARG requires an argument" 1>&2
		print_usage
		;;
	esac
	echo $DESKTOP
done
shift $((OPTIND -1))

distribution=$(grep -E '^(ID_LIKE)=' /etc/os-release | cut -d '=' -f 2)
if [ -z $distribution ]
then
	distribution=$(grep -E '^(ID)=' /etc/os-release | cut -d '=' -f 2)
	if [ -z $distribution ]
	then
		printf "Your ditribution does not seem to be supported...\n"
		exit 1
	fi
fi
if [ "$distribution" = "debian" ]
then
	package_manager="apt-get"
else
	printf "Your ditribution does not seem to be supported...\n"
	exit 1
fi

# Install oh-my-zsh
if command -v curl > /dev/null 2>&1
then
	yes | sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" "--unattended"
	if [ $? -ne 0 ]
	then
		printf "${RED}oh-my-zsh installation failed, aborting...\n${NC}"
		exit 1
	fi
fi

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
