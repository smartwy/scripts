#!/bin/bash
#
#Author:samrtwy(qq:120649294)
#Version:2.0
#Date:2017-04-23
#Descripton:According to the input partition table mode,disk,partition number,
#			size,file system type of an empty disk for sutomatic partitioning.

read  -p "Please input partition table mode ( 1:GPT | 2:MBR ) :" MKLB
read  -p "Please input device pathi ( exp:/dev/sdb ) :" DEPT
read  -p "Please input number of partitions :" PANU
read  -p "Please input partition size ( default M ) :" PASZ
read  -p "Please input partition type (ext3,ext4,xfs):" PTYPE

[[ -b ${DEPT} ]] || echo "Input is not device block!";exit 1
MP="mkpart"
PT="parted"
PY="primary" 
TMP_S=0 #partition size start
TMP_E=0 #partition size end
[[ "${PTYPE}" == "xfs" ]] && OP="-f"

if [[ "$MKLB" == "1" ]] || [[ "$MKLB" == "GPT" ]];then
	MKLB="gpt"
	${PT} -s ${DEPT} mklabel ${MKLB}
	for (( i=1;i<=${PANU};i++ ))
	do
			TMP_E=$((PASZ+TMP_E))
			${PT} -s ${DEPT} ${MP} ${PY} ${TMP_S} ${TMP_E}
			sleep 1
			mkfs.${PTYPE} ${OP} ${DEPT}${i} &>/dev/null || echo "${DEPT}${i} format error !" 
			TMP_S=$((TMP_E+1))
	done

elif [[ "$MKLB" == "2" ]] || [[ "$MKLB" == "MBR" ]];then
	MKLB="msdos"
	${PT} -s ${DEPT} mklabel ${MKLB}
	if [ ${PANU} -le 3 ]
	then
	for (( i=1;i<=3;i++ ))
	do
			TMP_E=$((PASZ+TMP_E))
			${PT} -s ${DEPT} ${MP} ${PY} ${TMP_S} ${TMP_E}
			sleep 1
			mkfs.${PTYPE} ${OP} ${DEPT}${i} &>/dev/null || echo "${DEPT}${i} format error !" 
			TMP_S=$((TMP_E+1))
	done
	fi

	if [ ${PANU} -eq 4 ]
	then
		for (( i=1;i<=4;i++ ))
		do
			if [ $i -eq 4 ]
			then
		         TMP_E=$((PASZ+TMP_E))
	       	     fdisk ${DEPT}<<EOF &>/dev/null
				n
				e
				$((TMP_E*1024+1))
			

				w
EOF
				 exit 0
			fi
			
			TMP_E=$((PASZ+TMP_E))
			${PT} -s ${DEPT} ${MP} ${PY} ${TMP_S} ${TMP_E}
			sleep 1
			mkfs.${PTYPE} ${OP} ${DEPT}${i} &>/dev/null || echo "${DEPT}${i} format error !" 
			TMP_S=$((TMP_E+1))
		
		done
	fi
	if [ ${PANU} -gt 4 ]
	then
		for (( i=1;i<=${PANU};i++ ))
		do
			if [ $i -eq 4 ]
			then
	       	     fdisk ${DEPT}<<EOF &>/dev/null
				n
				e
				$(($((TMP_E+PASZ))*1024+1))



				w
EOF
	       	     partprobe &>/dev/null
				 partx -a ${DEPT} &>/dev/null
				 let i=i+1
			fi

			if [ $i -gt 4 ]
			then
			
				for (( j=5;j<=${PANU};j++ ))
		        do

				 	TMP_S=$((TMP_E+1))
				 	TMP_E=$((PASZ+TMP_E))
		         	${PT} -s ${DEPT} ${MP} logical ${TMP_S} ${TMP_E}
					sleep 1
					mkfs.${PTYPE} ${OP} ${DEPT}${j} &>/dev/null || echo "${DEPT}${j} format error !" 
	       	 	    TMP_S=$((TMP_E+1))
					
					if [ $j -eq ${PANU} ]
					then
						exit 0
					fi
				done
			fi

			TMP_E=$((PASZ+TMP_E))
			${PT} -s ${DEPT} ${MP} ${PY} ${TMP_S} ${TMP_E}
			sleep 1
			mkfs.${PTYPE} ${OP} ${DEPT}${i} &>/dev/null || echo "${DEPT}${i} format error !" 
			TMP_S=$((TMP_E+1))

		done
	fi
else
	echo "Input ERROR!"
fi
