#!/bin/sh

VERSION=1.1 # version number
# exclude from the deploy
EXCLUDE=(app app.sh backup backup.sh bak .gitignore)
LIBNAME=ezaoo
MACAPPNAME=AccadAoo
DIR=$(echo ~/Documents/${MACAPPNAME})
APPNAME=${MACAPPNAME}.app
APP=${DIR}/${APPNAME} # app bundle
ZIP=${APP//.app/}-macos.zip
PATCHDIR=${APP}/Contents/Resources/patch/ # 'patch' dir inside bundle
PDLIBDIR=~/Library/Pd
for i in ${EXCLUDE[@]}; do EX+="--exclude=$i "; done

run() {
	if [[ "$1" == "deploy" ]] || [[ $1 == "d" ]]; then
		rsync -qaP ${EX} ${DIR}/bin/* ${PATCHDIR}
		rm -rf ${ZIP}
		cd ${DIR} && zip -r ${ZIP} ./*.app && cd - 
		echo "--- ${APPNAME} created."
		rsync -qaP ${EX} ${DIR}/bin/* ${PDLIBDIR}/${LIBNAME}
		echo "--- ${LIBNAME} created."
		cd ${PDLIBDIR}
		deken package -v ${VERSION} ${LIBNAME}
	elif [[ "$1" == "backup" ]] || [[ $1 == "b" ]]; then
		#	Find next backup item nubmer
		i=1
		if [[ -d ${DIR}/bak/bin_1 ]] ; then
			for dirs in ${DIR}/bak/* ; do 
				((i++))
			done
		fi
		rsync -aP ${EX} ${DIR}/bin/* ${DIR}/bak/bin_${i}
	elif [[ "$1" == "test" ]] || [[ $1 == "t" ]]; then
		open ${APP}
	elif [[ "$1" == "run" ]] || [[ $1 == "r" ]]; then
		pd -noprefs -lib aoo -jack -open ${DIR}/bin/${LIBNAME}.pd
	elif [[ "$1" == "upload" ]] || [[ $1 == "u" ]]; then
		cd ${PDLIBDIR}
		DEK=$(ls ${LIBNAME}*.dek)
		while true; do
		    read -p "Do you wish to upload ${DEK}?" yn
		    case $yn in
		        [Yy]* ) deken upload ${DEK}; break;;
		        [Nn]* ) exit;;
		        * ) echo "Please answer yes or no.";;
		    esac
		done
	else
		echo "Not implemented: $1"
	fi
}

if [[ $# -gt 1 ]]; then
	echo "Ignoring extra arguments after $1"
	run $1
elif [[ $# -eq 1 ]]; then
	run $1
else
	echo "No arguments passed."
	echo "--- Usage: ./app [t|d|b|r]"
	printf "%6s\t(%s)%s\n"  "test"   "t" "ests the app bundle"
	printf "%6s\t(%s)%s\n"  "deploy" "d" "eploys & zips patch in app bundle"
	printf "%6s\t(%s)%s\n"  "backup" "b" "ackups <bin>"
	printf "%6s\t(%s)%s\n"  "run"    "r" "uns the pd file (development)"
fi
