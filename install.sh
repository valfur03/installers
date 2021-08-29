#!/bin/sh

NC="\033[0m"
BOLD="\033[1m"
ULINE="\033[4m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"

#set -ux;

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
		printf "${RED}Desktop environment already set to '%s'${NC}\n" $DESKTOP 1>&2
		exit 1
	fi
}

check_commands_exist()
{
	missing_command=0
	while [ $# -gt 0 ]
	do
		if ! command -v $1 > /dev/null 2>&1
		then
			printf "${RED}'%s' is not installed...${NC}\n" $1
			missing_command=1
		fi
		shift 1;
	done
	[ $missing_command -gt 0 ] && exit 1
}
check_commands_exist 'grep' 'curl' 'git' 'vim' 'mkdir'

command_summary()
{
	if [ $1 -eq 0 ]
	then
		printf "${GREEN}%-70s installed${NC}\n" "$2"
	else
		printf "${YELLOW}%-57s installation failed...\n${NC}" "$2"
		[ -r .last-output ] && cat .last-output
	fi
}

# Options
# 
# g, gnome -> Gnome
# k, kde-plasma -> KDE
# x, xfce -> xfce

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
		printf "${RED}Invalid Option: -%s${NC}\n" $OPTARG 1>&2
		print_usage
		;;
	:)
		printf "${RED}Invalid Option: -%s requires an argument${NC}\n" $OPTARG 1>&2
		print_usage
		;;
	esac
done
shift $((OPTIND -1))

distribution=$(grep -E '^(ID_LIKE)=' /etc/os-release | cut -d '=' -f 2)
if [ -z $distribution ]
then
	distribution=$(grep -E '^(ID)=' /etc/os-release | cut -d '=' -f 2)
	if [ -z $distribution ]
	then
		printf "${RED}Your ditribution does not seem to be supported...${NC}\n"
		exit 1
	fi
fi
if [ "$distribution" = "debian" ]
then
	package_manager="apt-get"
else
	printf "${RED}Your ditribution does not seem to be supported...${NC}\n"
	exit 1
fi

# Install oh-my-zsh
yes | sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" "--unattended" > .last-output 2>&1
command_summary $? 'oh-my-zsh'

# Configure VIM
git clone https://github.com/VundleVim/Vundle.vim.git \
	~/.vim/bundle/Vundle.vim > .last-output 2>&1
command_summary $? 'vundle (VIM plugin manager)'
curl -o ~/.vimrc https://gist.githubusercontent.com/valfur03/f49e289c6f0b31c24fb167ec8fac461a/raw/.vimrc > .last-output 2>&1
command_summary $? '.vimrc'
vim +PluginInstall +qall > .last-output 2>&1
command_summary $? 'vundle plugins'
mkdir -p ~/.vim/plugin/ftdetect > .last-output 2>&1
echo 'au BufNewFile,BufRead *.c set cindent' >> ~/.vim/plugin/ftdetect/c.vim > .last-output 2>&1
command_summary $? 'ftdetect c'

# Configure zsh
curl -o ~/.zshrc https://gist.githubusercontent.com/valfur03/f49e289c6f0b31c24fb167ec8fac461a/raw/.zshrc > .last-output 2>&1
command_summary $? '.zshrc'
curl -o ~/.zsh_aliases https://gist.githubusercontent.com/valfur03/f49e289c6f0b31c24fb167ec8fac461a/raw/.zsh_aliases > .last-output 2>&1
command_summary $? '.zsh_aliases'
curl -o ~/.oh-my-zsh/themes/custom.zsh-theme https://gist.githubusercontent.com/valfur03/f49e289c6f0b31c24fb167ec8fac461a/raw/custom.zsh-theme > .last-output 2>&1
command_summary $? 'custom.zsh-theme'

rm -f .last-output
