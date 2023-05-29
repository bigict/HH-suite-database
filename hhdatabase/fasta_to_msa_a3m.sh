#!/bin/sh
runtime=$1
memory=$2
threads=$3

in_tmp=$(mktemp /tmp/mmseq-in.XXXXXXXX)
out_tmp="/tmp/mmseq-msa.${in_tmp##*.}"
a3m_tmp="/tmp/mmseq-a3m.${in_tmp##*.}"

# Exit, HUP, INT, QUIT, PIPE, TERM
trap "rm -f $in_tmp; rm -f $out_tmp; rm -f $a3m_tmp; exit 1" 0 1 2 3 13 15

cat /dev/stdin > $in_tmp
sed -i 's/\*/-/g' $in_tmp
ulimit -c 0

fasta_headers=$(grep -c '^>' $in_tmp)
if [ "$fasta_headers" -gt "1" ]; then
    timeout ${runtime} famsa $in_tmp $out_tmp -t $3 >/dev/null
    ret=$?

    # Clustal O does not handle MSAs with only one sequence well
    if [ $ret -ne 0  ]; then
      rm -f $out_tmp
      timeout ${runtime} clustalo --force -i $in_tmp -o $out_tmp --MAC-RAM=${memory} --threads=$3 >/dev/null
      ret=$?

      if [ $ret -ne 0 ]; then
          rm -f $out_tmp
          timeout ${runtime} kalign -q -i $in_tmp -o $out_tmp >/dev/null
      fi;
    fi;
else
    rm -f $out_tmp
    out_tmp=$in_tmp
fi;
reformat.pl fas a3m $out_tmp $a3m_tmp >/dev/null
hhconsensus -maxres 65535 -i $a3m_tmp -o stdout -v 0
# Cleanup
rm -f $in_tmp
rm -f $out_tmp
rm -f $a3m_tmp
trap 0
exit
