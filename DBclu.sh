#!/bin/bash -ex
[ "$#" -lt 2  ] && echo "Please provide <sequenceDB> <outDir>"  && exit 1;
[ ! -f "$1"   ] && echo "Sequence database $1 not found!"       && exit 1;
[   -d "$2"   ] && echo "Output directory $2 exists already!"   && exit 1;

function abspath() {
    if [ -d "$1" ]; then
        (cd "$1"; pwd)
    elif [ -f "$1" ]; then
        if [[ $1 == */* ]]; then
            echo "$(cd "${1%/*}"; pwd)/${1##*/}"
        else
            echo "$(pwd)/$1"
        fi
    fi
}

RELEASE="${3:-$(date "+%Y_%m")}"
SHORTRELEASE="${4:-$(date "+%y%m")}"

INPUT=$1
OUTDIR=$2/$RELEASE

TMPPATH=$OUTDIR/tmp
mkdir -p $TMPPATH

OUTDIR=$(abspath $OUTDIR)
TMPPATH=$(abspath $TMPPATH)


SEQUENCE_DB="$OUTDIR/mmseqs_db"
mmseqs createdb "$INPUT" "${SEQUENCE_DB}" # --max-seq-len 14000

date --rfc-3339=seconds
# cluster down to 30%
mmseqs linclust ${SEQUENCE_DB} "$OUTDIR/DBclu30_$RELEASE" "$TMPPATH" --min-seq-id 0.3 --cov-mode 1 -c 0.9
date --rfc-3339=seconds
