#!/bin/bash

DATE="date"
# On Mac use gdate from `brew install coreutils`
if [[ "$OSTYPE" == "darwin"* ]]; then
    DATE="gdate"
fi
PAD=$(printf '%0.1s' "."{1..48})

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd "$DIR"
TARGET="target"
CONFIG="definitions.config"

getTime() {
    echo $(($($DATE +%s%N)/1000000))
}
getFormattedTime() {
    local mils=$(($1%1000))
    local secs=$(($1/1000%60))
    local mins=$(($1/(1000*60)%60))
    local hours=$(($1/(1000*60*60)))
    if [ $hours -gt 0 ]; then
        printf "%02d:%02d:%02d hours" "$hours" "$mins" "$secs"
    elif [ $mins -gt 0 ]; then
		printf "%02d:%02d mins" "$mins" "$secs"
	else
        printf "%02d:%02d secs" "$secs" "$mils"
    fi
}
function getString () {
	echo $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $1 | head -n 1)
}
function getFields() {	
	FIELDS=""
	PREFIX="-"
	COUNT=1
	until [[ $COUNT -gt $1 ]]; do
		FIELDS+=" $PREFIX"
		FIELDS+="Test$COUNT"
		FIELDS+="='$(getString $2)"
		FIELDS+="'"
		let COUNT=COUNT+1
	done
	echo "$FIELDS"
}

function resetFiles() {
	./cleanup.sh
}

if [[ -z "$1" ]]; then
	echo "ERROR: missing field number"
	exit 1
fi
if [[ -z "$2" ]]; then
	echo "ERROR: Missing field text length"
	exit 1
fi
if [[ $1 -gt 100 ]]; then
	echo "Not enough field definitions to support this write"
	exit 1
fi

echo "Number of fields: $1"
echo "Text length of fields: $2"

if [[ -z "$3" ]]; then
	echo "Single pass....."
	resetFiles
	METADATA=$(getFields $1 $2)
	ls -l "$TARGET"
	execution_start=$(getTime)
	echo "exiftool -config $CONFIG $METADATA $TARGET"
	echo "$(exiftool -config $CONFIG $METADATA $TARGET)"
	execution_end=$(getTime)
	execution_total=$(printf "%s%s" ${PAD:13} "$(getFormattedTime $((execution_end-execution_start)))")
	echo ""
	echo "[INFO] Execution time $execution_total"
else
	echo "Looping $3 times"
	LOOP=1
	OVERALL=0
	until [[ $LOOP -gt $3 ]]; do
		echo "Loop #$LOOP"
		resetFiles
		METADATA=$(getFields $1 $2)
		
		ls -l "$TARGET"
		execution_start=$(getTime)
		echo "exiftool -config $CONFIG $METADATA $TARGET"
		echo "$(exiftool -config $CONFIG $METADATA $TARGET)"
		execution_end=$(getTime)
		execution_total=$(printf "%s%s" ${PAD:13} "$(getFormattedTime $((execution_end-execution_start)))")
		let OVERALL=OVERALL+$((execution_end-execution_start))
		echo ""
		echo "[INFO] Execution time $execution_total"
		let LOOP=LOOP+1
	done 
	echo "[INFO] Average: $(getFormattedTime $(($OVERALL / $3)))"
fi


