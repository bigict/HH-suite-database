#!/bin/bash -ex

function make_finalize() {
    local BASE="$1"
    local RELEASE="$2"
    local PREFIX="$3"
    local OUTNAME="${PREFIX}_${RELEASE}"
    local DB="${BASE}/${OUTNAME}"
    local TMPPATH="$4"


    ##sort hhms and a3m according to sequence length
    sort -k 3 -n "${DB}_cs219.ffindex" | cut -f1 > "${TMPPATH}_sort_by_length.dat"
    for type in a3m hhm; do
        ffindex_order "${TMPPATH}_sort_by_length.dat" ${DB}_${type}.ff{data,index} ${TMPPATH}_${type}_opt.ff{data,index}

        mv -f "${TMPPATH}_${type}_opt.ffdata" "${DB}_${type}.ffdata"
        mv -f "${TMPPATH}_${type}_opt.ffindex" "${DB}_${type}.ffindex"
    done


    md5deep ${DB}_{a3m,hhm,cs219}.ff{data,index} > "${DB}_md5sum"
    sed -i "s|${BASE}/||g" "${DB}_md5sum"

    tar -cv --use-compress-program=gzip \
        --show-transformed-names --transform "s|${BASE:1}/|DBclu30_${RELEASE}/|g" \
        -f "$TMPPATH/DBclu30_${RELEASE}_hhsuite.tar.gz" \
        ${DB}_{a3m,hhm,cs219}.ff{data,index} "${DB}_md5sum"
}

make_finalize $1 $2 $3 $4
