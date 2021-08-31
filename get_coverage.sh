#!/bin/bash --login
#$ -l mem256
#$ -pe smp.pe 16 # … reserves 16 cores
#$ -j y
#$ -o logs_researchproject2
#$ -hold_jid search_spidroin.sh

module load apps/anaconda3/5.2.0/bin
source activate software

cd /net/scratch2/a73590hl/data/$1

#blast database and magicblast
#/mnt/iusers01/sbc01/a73590hl/software/ncbi-blast-2.11.0+/bin/makeblastdb -in trinity_assembly_$1.Trinity.fasta -out blastdb_$1_Trinity_RNA -parse_seqids -dbtype nucl

#magicblast -query $1_pass_1.fastq -db blastdb_$1_Trinity_RNA -num_threads 16 -infmt fastq -outfmt tabular

#magicblast -query $1_pass_2.fastq -db blastdb_$1_Trinity_RNA -num_threads 16 -infmt fastq #-outfmt tabular

###
#blast database and magicblast
/mnt/iusers01/sbc01/a73590hl/software/ncbi-blast-2.11.0+/bin/makeblastdb -in RNA_seq_match_$1.fasta -out blastdb_$1_RNA_seq_match -parse_seqids -dbtype nucl

magicblast -query $1_pass_1.fastq -db blastdb_$1_RNA_seq_match -num_threads 16 -infmt fastq -outfmt tabular

magicblast -query $1_pass_2.fastq -db blastdb_$1_RNA_seq_match -num_threads 16 -infmt fastq -outfmt tabular