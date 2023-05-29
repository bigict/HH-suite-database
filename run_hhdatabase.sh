#!/bin/bash -ex
#BSUB -q mpi-long+
#BSUB -o out.%J
#BSUB -e err.%J
#BSUB -W 120:00
#BSUB -n 128
#BSUB -a openmpi
#BSUB -m hh
#BSUB -R cbscratch
#BSUB -R "span[ptile=16]"

function make_a3m () {
    local BASE="$1"
    local RELEASE="$2"
    local PREFIXCLUST="$3"
    local CLUSTDB="${BASE}/${PREFIXCLUST}_${RELEASE}"

    local TMPPATH="$4"
    mkdir -p "${TMPPATH}"
    local TMPDB="${TMPPATH}/${PREFIXCLUST}_${RELEASE}"
    mmseqs createseqfiledb "${BASE}/mmseqs_db" "${CLUSTDB}" "${TMPDB}_fasta" --min-sequences 3
    date --rfc-3339=seconds
    num1=$(($(ls ${TMPDB}_fasta*[0-9]|wc -l)-1))
    mv "${TMPDB}_fasta.index" "${TMPDB}_fasta.ffindex"
    for i in $(seq 0 $num1); do
      cat "${TMPDB}_fasta.${i}" >> "${TMPDB}_fasta.ffdata"
    done
    date --rfc-3339=seconds
    make_a3m.sh "${TMPDB}_fasta" "${TMPDB}_a3m" "${TMPPATH}"
    date --rfc-3339=seconds

    mv -f "${TMPDB}_a3m.ffdata" "${CLUSTDB}_a3m.ffdata"
    mv -f "${TMPDB}_a3m.ffindex" "${CLUSTDB}_a3m.ffindex"
}

function make_hhdatabase () {
    local BASE="$1"
    local RELEASE="$2"
    local PREFIXCLUST="$3"
    local CLUSTDB="${BASE}/${PREFIXCLUST}_${RELEASE}"

    local TMPPATH="$4"
    mkdir -p ${TMPPATH}
    date --rfc-3339=seconds
    make_a3m "${BASE}" "${RELEASE}" "${PREFIXCLUST}" "${TMPPATH}"
    date --rfc-3339=seconds
    make_hhmake.sh "${CLUSTDB}_a3m" "${CLUSTDB}_hhm" "${TMPPATH}"
    date --rfc-3339=seconds
    make_cstranslate.sh ${CLUSTDB}_a3m ${CLUSTDB}_cs219
    date --rfc-3339=seconds
    make_finalize.sh "${BASE}" "$RELEASE" "${PREFIXCLUST}" "${TMPPATH}"
    mv -f "${TMPPATH}/DBclu30_${RELEASE}_hhsuite.tar.gz" "${BASE}/.."
}

source ./paths.sh
mkdir -p "${TARGET}/tmp/clust"
make_hhdatabase "${TARGET}" "${RELEASE}" "DBclu30" "${TARGET}/tmp/clust"
#make_a3m "${TARGET}" "${RELEASE}" "DBclu50" "${TARGET}/tmp/clust"
#make_a3m "${TARGET}" "${RELEASE}" "DBclu90" "${TARGET}/tmp/clust"

