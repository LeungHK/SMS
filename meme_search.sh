#!/bin/bash --login
#$ -l mem256
#$ -pe smp.pe 16 # … reserves 16 cores
#$ -j y
#$ -o logs_researchproject2
#$ -hold_jid search_spidroin.sh

#qsub meme_search.sh ERR356424
module load apps/anaconda3/5.2.0/bin
source activate spider-motif

cd /net/scratch2/a73590hl/data/$1

python /mnt/iusers01/sbc01/a73590hl/software/Spider-Pipeline/spider_pipeline_runner.py -mk spider_pipeline_$1

python /mnt/iusers01/sbc01/a73590hl/software/Spider-Pipeline/spider_pipeline_runner.py -rme /net/scratch2/a73590hl/data/$1/spider_pipeline_$1 /net/scratch2/a73590hl/data/$1/aa_seq_sorted_match_$1.fasta -t 16
