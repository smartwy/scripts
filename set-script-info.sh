#!/bin/bash
#Author:samrtwy()
#Version:2.1
#Date:2017-05-13
#Descripton: add script description info for option 
#
if [ -z "$1" ] 
then 
	echo "Please input script name or path. "
	exit 1
elif [ "$1" == "--help" ]
then 
	echo "Usage: ./set-script-info.sh SCRIPT_NAME"
	exit 2
elif ! [ -f "$1" ]
then
	echo "Please enter the correct script."
	exit 3
fi

filename=$(cd $(dirname $1) && pwd)/$1 || exit 1 

function option() {
for tm in $@
do
		arg=$1
		meg=$2
		case $arg in
			-a|--author)
			sed -i "/[Aa]uthor/d" $filename
			sed -i "2c# Author:  ${meg}" $filename
			[ $? -eq 0 ] && echo -e "Add Autor OK !\n"
			shift 2
			[[ -z $@ ]] && exit 0
			;;
			-t|--time)
			sed -i "/[Tt]ime/d" $filename
			sed -i "3c# Time:    ${meg}" $filename
			[ $? -eq 0 ] && echo -e "Add Time OK !\n"
			shift 2
			[[ -z $@ ]] && exit 0
			;;	
			-d|--description)
			sed -i "/[Dd]escription/d" $filename
			sed -i "5c# Description:${meg}" $filename
			[ $? -eq 0 ] && echo -e "Add Description OK !\n"
			shift 2
			[[ -z $@ ]] && exit 0
			;;	
			-v|--version)
			sed -i "/[Vv]ersion/d" $filename
			sed -i "4c# Version: ${meg}" $filename
			[ $? -eq 0 ] && echo -e "Add Version OK !\n"
			shift 2
			[[ -z $@ ]] && exit 0
			;;	
			-h|--help)
			cat << EOF
Usage: scriptname [-a|--author USER] [-t|--time DATE] [-d|--descript MESSAGE] [-v|--version DIGIT] [-h|--help]"
EOF
			exit 1
			;;	
			*)
			cat << EOF
Usage: scriptname [-a|--author USER] [-t|--time DATE] [-d|--descript MESSAGE] [-v|--version DIGIT] [-h|--help]"
EOF
			exit 2
			;;	
		esac
done
}

function sai() {
	if [ ! -s $filename ]
	then
		shift
		echo -e '#!/bin/bash\n\n\n\n' > $filename
		option $@
	elif [ -f $filename ]
	then
		shift
		read -p "The file no empty ! Whether to continue?(Y/N):" YN
		[[ $YN =~ [Yy] ]] || exit 1
		sed -i 's@^#!.*$@#!/bin/bash@g' $filename
		option $@
	else
		echo "ERROR !"
	fi
}

sai "$@"
