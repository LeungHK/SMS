#!/bin/bash --login
#$ -hold_jid search_spidroin.sh

module load apps/anaconda3/5.2.0/bin
source activate software

cd /data/$1

#blast database and magicblast
/ncbi-blast-2.11.0+/bin/makeblastdb -in RNA_seq_match_$1.fasta -out blastdb_$1_RNA_seq_match -parse_seqids -dbtype nucl

magicblast -query $1_pass_1.fastq -db blastdb_$1_RNA_seq_match -num_threads 16 -infmt fastq -outfmt tabular

magicblast -query $1_pass_2.fastq -db blastdb_$1_RNA_seq_match -num_threads 16 -infmt fastq -outfmt tabular
