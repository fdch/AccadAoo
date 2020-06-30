#!/bin/sh

VERSION=1 # version number

# exclude from the deploy
EXCLUDE=(app app.sh backup backup.sh bak .gitignore)

APP=AccadAoo-${VERSION}.app # app bundle

PATCHDIR=${APP}/Contents/Resources/patch/ # 'patch' dir inside bundle

for i in ${EXCLUDE[@]}; do EX+="--exclude=$i "; done

run() {
	if [[ "$1" == "deploy" ]] || [[ $1 == "d" ]]; then
		rsync -aPiv ${EX} ../bin/* ${PATCHDIR}
		rm -rf ${APP}.zip
		zip -r ${APP}.zip ${APP} setup.txt 
	elif [[ "$1" == "backup" ]] || [[ $1 == "b" ]]; then
		source ../backup.sh ${EX}
	elif [[ "$1" == "test" ]] || [[ $1 == "t" ]]; then
		open ${APP}
	elif [[ "$1" == "run" ]] || [[ $1 == "r" ]]; then
		pd -jack -open main.pd
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
	printf "%6s\t(%s)%s\n"  "backup" "b" "ackups <bin> with backup.sh"
	printf "%6s\t(%s)%s\n"  "run"    "r" "uns the pd file (development)"
fi
