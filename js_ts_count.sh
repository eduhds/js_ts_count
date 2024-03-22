#!/bin/bash

show_message() {
    printf "\n"
    
    if command -v column &> /dev/null; then
        echo " | files | %
JS | $1 | $3
TS | $2 | $4" | column -t -s '|'
    else
        echo "JS files: $1 ($3)%"
        echo "TS files: $2 ($4)%"
    fi

    printf "\n"
}

if [ -z "$1" ]; then
    ROOT_DIR=.
else
    ROOT_DIR=$1
fi

JS_FILES=($(find $ROOT_DIR -type f -name "*.js"))
TS_FILES=($(find $ROOT_DIR -type f -name "*.ts"))
DTS_FILES=($(find $ROOT_DIR -type f -name "*.d.ts"))
TSX_FILES=($(find $ROOT_DIR -type f -name "*.tsx"))

TOT_JS="${#JS_FILES[@]}"
TOT_TS=$(( ${#TS_FILES[@]} - ${#DTS_FILES[@]} ))
TOT_TSX="${#TSX_FILES[@]}"
TOT_TS=$(( $TOT_TS + $TOT_TSX ))

TOT_FILES=$(( $TOT_JS + $TOT_TS ))

if [ $TOT_FILES -eq 0 ]; then
    show_message 0 0 0 0
else
    if command -v node &> /dev/null; then
        JS_PERCENT=$(node -e "console.log(Math.round($TOT_JS * 100 / $TOT_FILES))")
        TS_PERCENT=$(node -e "console.log(Math.round($TOT_TS * 100 / $TOT_FILES))")
    elif command -v python &> /dev/null; then
        JS_PERCENT=$(python -c "print(round($TOT_JS * 100 / $TOT_FILES))")
        TS_PERCENT=$(python -c "print(round($TOT_TS * 100 / $TOT_FILES))")
    elif command -v ruby &> /dev/null; then
        JS_PERCENT=$(ruby -e "puts ($TOT_JS * 100 / $TOT_FILES).round")
        TS_PERCENT=$(ruby -e "puts ($TOT_TS * 100 / $TOT_FILES).round")
    elif command -v perl &> /dev/null; then
        JS_PERCENT=$(perl -e "printf '%.0f', ($TOT_JS * 100 / $TOT_FILES)")
        TS_PERCENT=$(perl -e "printf '%.0f', ($TOT_TS * 100 / $TOT_FILES)")
    else
        JS_PERCENT=$(( $TOT_JS * 100 / $TOT_FILES ))
        TS_PERCENT=$(( $TOT_TS * 100 / $TOT_FILES ))
    fi

    show_message $TOT_JS $TOT_TS $JS_PERCENT $TS_PERCENT
fi
