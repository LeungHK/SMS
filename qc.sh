#!/bin/bash --login
#$ -l mem512 # Uses a high-memory node and
#$ -pe smp.pe 16 # … reserves 16 cores
#$ -j y
#$ -o logs_researchproject2
#$ -hold_jid search_spidroin.sh

# -hold_jid both_fastq-dump_trinity.sh

#qsub qc.sh ERR356424

module load apps/anaconda3/5.2.0/bin
source activate software

#cd /mnt/iusers01/sbc01/a73590hl/data/$1
cd /net/scratch2/a73590hl/data/$1

#detonate.sh
rsem-eval-estimate-transcript-length-distribution trinity_assembly_$1.Trinity.fasta parameter_file_detonate_$1

L=$(sed -e 's/^[^0-9]*\([0-9][0-9]*\).*/\1/' parameter_file_detonate_$1)

rsem-eval-calculate-score --paired-end $1_pass_1.fastq $1_pass_2.fastq trinity_assembly_$1.Trinity.fasta detonate_$1 $L --time -p 16


#TransRate
sed 's_reverse/2_forward/1_g' $1_pass_2.fastq > $1_identical_pass_2.fastq #make fastq names match for transrate to work

#sed 's_reverse/2_forward/1_g' SRR6997754_pass_2.fastq > Trinity.fixed.fastq
transrate --assembly trinity_assembly_$1.Trinity.fasta --threads 16 --output transrate_trinity_$1

transrate --assembly RNA_seq_sorted_match_$1.fasta --left $1_pass_1.fastq --right $1_identical_pass_2.fastq --threads 16 --output transrate_match_$1

#transrate --assembly trinity_assembly_$1.Trinity.fasta --left $1_pass_1.fastq --right $1_identical_pass_2.fastq --threads 16 --output transrate_$1
