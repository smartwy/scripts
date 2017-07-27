#!/bin/bash
#
#
j=1
while [ $j -le 9 ]
do 
	for (( i=1;i<=$j;i++ ))
	do
		JI=$[i*j]
		echo -e "${i}*${j}=${JI}  \c" #&& [[ $i == $j ]] && echo -e "\n" && break 1
		if [[ $i == $j ]]
		then
			echo -e "\n"
			break 1
		fi
	done
	let j++
done
