#!/bin/bash --login
#$ -hold_jid search_spidroin.sh

module load apps/anaconda3/5.2.0/bin
source activate software

cd data/$1

#detonate.sh
rsem-eval-estimate-transcript-length-distribution trinity_assembly_$1.Trinity.fasta parameter_file_detonate_$1

L=$(sed -e 's/^[^0-9]*\([0-9][0-9]*\).*/\1/' parameter_file_detonate_$1)

rsem-eval-calculate-score --paired-end $1_pass_1.fastq $1_pass_2.fastq trinity_assembly_$1.Trinity.fasta detonate_$1 $L --time -p 16


#TransRate
sed 's_reverse/2_forward/1_g' $1_pass_2.fastq > $1_identical_pass_2.fastq #make fastq names match for transrate to work

transrate --assembly trinity_assembly_$1.Trinity.fasta --threads 16 --output transrate_trinity_$1

transrate --assembly RNA_seq_sorted_match_$1.fasta --left $1_pass_1.fastq --right $1_identical_pass_2.fastq --threads 16 --output transrate_match_$1
