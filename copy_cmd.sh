#!/bin/bash
#
#
DIR='/tmp/test'
while true
do
	read -p "Please input commond :" COM
	[ "$COM" == "quit" ] && { echo "EXIT !";exit; }
	COMP=`whereis $COM | cut -d' ' -f2 ` 
	DIRNAME=`dirname ${COMP}`	
	if [ -x "${COMP}" ] ;then
		echo $COMP
		ldd ${COMP}&>/dev/null
		[ -d ${DIR}${DIRNAME} ] || mkdir -p ${DIR}${DIRNAME}
		cp -arf $COMP ${DIR}${DIRNAME}
		
		LIST=`ldd ${COMP} | rev | cut -d " " -f2 | rev`
		for i in $LIST;
			do
				DIRNAMELIB=`dirname ${i}`
				[ -d ${DIR}${DIRNAMELIB} ] || mkdir -p ${DIR}${DIRNAMELIB}
				cp -arf ${i} ${DIR}${DIRNAMELIB}
			done
	else
		echo "input error !"
	fi
done
