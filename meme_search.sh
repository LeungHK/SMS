#!/bin/bash --login
#$ -hold_jid search_spidroin.sh

module load apps/anaconda3/5.2.0/bin
source activate spider-motif

cd /data/$1

python Spider-Pipeline/spider_pipeline_runner.py -mk spider_pipeline_$1

python Spider-Pipeline/spider_pipeline_runner.py -rme /data/$1/spider_pipeline_$1 /data/$1/aa_seq_sorted_match_$1.fasta -t 16
