#!/bin/sh

VERSION=1 # version number

# exclude from the deploy
EXCLUDE=(app app.sh backup backup.sh bak .gitignore)

DIR=$(echo ~/Documents/AccadAoo)

APP=${DIR}/AccadAoo-${VERSION}.app # app bundle

PATCHDIR=${APP}/Contents/Resources/patch/ # 'patch' dir inside bundle

for i in ${EXCLUDE[@]}; do EX+="--exclude=$i "; done

run() {
	if [[ "$1" == "deploy" ]] || [[ $1 == "d" ]]; then
		rsync -qaP ${EX} ${DIR}/bin/* ${PATCHDIR}
		rm -rf ${APP}.zip
		cd ${DIR} && zip -r ${APP//.app/}.zip ./*.app ./setup.txt && cd -
		# zip -rqj ${DIR}/${APP}.zip ${APP} ${DIR}/setup.txt 
		echo "--- App created."
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
		pd -noprefs -lib aoo -jack -open ${DIR}/bin/main.pd
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
