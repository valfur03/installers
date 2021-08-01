#!/bin/sh

# Options
# 
# g, gnome -> Gnome
# k, kde-plasma -> KDE
# x, xfce -> xfce

print_usage()
{
	exec 1>&2
	printf "Usage: %s [-gkx] distribution\n\n" $(basename "$0")
	printf "Distributions:\n\t- debian\n"
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
