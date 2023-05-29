#!/bin/bash -ex

function make_a3m() {
	readonly INPUT=$1
	readonly OUTPUT=$2
	readonly TMPPATH=$3

	readonly PREFIX=${INPUT##*/}
	readonly TMPOUT="${TMPPATH}/${PREFIX}"
  total=$(wc -l ${INPUT}.ffindex | cut -f1 -d" ")
  echo "total=$total" > dat_tmp
date --rfc-3339=seconds

	#build a3m's
    export OMP_NUM_THREADS=8
	mpirun -npernode 24 --bind-to none ffindex_apply_mpi -d ${OUTPUT}.ffdata -i ${OUTPUT}.ffindex ${INPUT}.ff{data,index} -- fasta_to_msa_a3m.sh 1h 6000 24

	#remove presumably wrong clusters
	grep "\s1$" ${OUTPUT}.ffindex | cut -f1 > ${TMPOUT}_misaligned_a3ms_0.dat
	nr_entries=$(wc -l ${TMPOUT}_misaligned_a3ms_0.dat | cut -f1 -d" ")
	echo "misaligned_1=$nr_entries" >> dat_tmp
  if [ "$nr_entries" == "0" ]; then
		exit 0;
	fi
	ffindex_modify -u -f ${TMPOUT}_misaligned_a3ms_0.dat ${OUTPUT}.ffindex

	##retry presumably wrong clusters with more memory, more threads and longer runtime
	##first repair iteration
	while read f;
	do
    ffindex_get ${INPUT}.ff{data,index} $f > $f
    ffindex_build -as ${TMPOUT}_missing_fasta_1.ff{data,index} $f
    rm -f $f
  done < ${TMPOUT}_misaligned_a3ms_0.dat
date --rfc-3339=seconds

	#retry presumably wrong clusters with more memory, more threads and longer runtime
    export OMP_NUM_THREADS=16
	mpirun -npernode 12 --bind-to none ffindex_apply_mpi -d ${TMPOUT}_missing_a3m_1.ffdata -i ${TMPOUT}_missing_a3m_1.ffindex ${TMPOUT}_missing_fasta_1.ff{data,index} -- fasta_to_msa_a3m.sh 3h 30000 16
	grep "\s1$" ${TMPOUT}_missing_a3m_1.ffindex | cut -f1 > ${TMPOUT}_misaligned_a3ms_1.dat
	ffindex_modify -u -f ${TMPOUT}_misaligned_a3ms_1.dat ${TMPOUT}_missing_a3m_1.ffindex
	ffindex_build -as ${OUTPUT}.ff{data,index} -i ${TMPOUT}_missing_a3m_1.ffindex -d ${TMPOUT}_missing_a3m_1.ffdata


	#retry presumably wrong clusters with more memory, more threads and longer runtime
	nr_entries=$(wc -l ${TMPOUT}_misaligned_a3ms_1.dat | cut -f1 -d" ")
  echo "misaligned_2=$nr_entries" >> dat_tmp
  if [ "$nr_entries" == "0" ]; then
    exit 0;
  fi

	##second repair iteration
	while read f;
	do
        ffindex_get ${INPUT}.ff{data,index} $f > $f
        ffindex_build -as ${TMPOUT}_missing_fasta_2.ff{data,index} $f
        rm -f $f
	done < ${TMPOUT}_misaligned_a3ms_1.dat
date --rfc-3339=seconds

    export OMP_NUM_THREADS=32
	mpirun -npernode 6 --bind-to none ffindex_apply_mpi -d ${TMPOUT}_missing_a3m_2.ffdata -i ${TMPOUT}_missing_a3m_2.ffindex ${TMPOUT}_missing_fasta_2.ff{data,index} -- fasta_to_msa_a3m.sh 8h 60000 32
	grep "\s1$" ${TMPOUT}_missing_a3m_2.ffindex | cut -f1 > ${TMPOUT}_misaligned_a3ms_2.dat
	ffindex_modify -u -f ${TMPOUT}_misaligned_a3ms_2.dat ${TMPOUT}_missing_a3m_2.ffindex
  nr_entries=$(wc -l ${TMPOUT}_misaligned_a3ms_2.dat | cut -f1 -d" ")
  echo "misaligned_3=$nr_entries" >> dat_tmp
	##merging
	ffindex_build -as ${OUTPUT}.ff{data,index} -i ${TMPOUT}_missing_a3m_2.ffindex -d ${TMPOUT}_missing_a3m_2.ffdata
date --rfc-3339=seconds
}

make_a3m $1 $2 $3
