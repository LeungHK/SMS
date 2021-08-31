#!/bin/bash --login

module load apps/anaconda3/5.2.0/bin
source activate software
module load apps/samtools/1.9/gcc-4.8.5 #samtools for trinity

cd /data

mkdir $1
cd $1

/sratoolkit.2.11.0-ubuntu64/bin/fastq-dump --defline-seq '@$sn[_$rn]/$ri' --split-3 --skip-technical --clip --dumpbase --read-filter pass $1

#Trinity
Trinity --seqType fq --max_memory 150G --CPU 16 --left $1_pass_1.fastq --right $1_pass_2.fastq --SS_lib_type FR --output trinity_assembly_$1 --no_bowtie --no_normalize_reads --full_cleanup #--no_salmon
