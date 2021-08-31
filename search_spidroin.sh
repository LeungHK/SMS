#!/bin/bash --login
#$ -l mem256
#$ -pe smp.pe 16 # … reserves 16 cores
#$ -j y
#$ -o logs_researchproject2
#$ -hold_jid both_fastq-dump_trinity.sh

#qsub search_spidroin.sh ERR356424

module load apps/anaconda3/5.2.0/bin
source activate software
module load apps/samtools/1.9/gcc-4.8.5

cd /net/scratch2/a73590hl/data/$1

#translate6frames to amino acid
/mnt/iusers01/sbc01/a73590hl/software/bbmap/translate6frames.sh in=trinity_assembly_$1.Trinity.fasta tag=t out=bbmap_translate_manylines_$1_prot.fa

#concatenate bbmap aa-sequence output from multiple lines to single lines
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < bbmap_translate_manylines_$1_prot.fa > bbmap_translate_$1_prot.fa

#HMMER 3.1b1 (Eddy, 2011) hmmsearch

hmmsearch -o hmmer_$1_RP1-2.report -A hmmer_$1_RP1-2.aln --tblout hmmer_$1_RP1-2.txt --cpu $NSLOTS /mnt/iusers01/sbc01/a73590hl/software/silkpipe/RP1-2.hmm bbmap_translate_$1_prot.fa

hmmsearch -o hmmer_$1_Spidroin_MaSp.report -A hmmer_$1_Spidroin_MaSp.aln --tblout hmmer_$1_Spidroin_MaSp.txt --cpu $NSLOTS /mnt/iusers01/sbc01/a73590hl/software/silkpipe/Spidroin_MaSp.hmm bbmap_translate_$1_prot.fa

hmmsearch -o hmmer_$1_Spidroin_N.report -A hmmer_$1_Spidroin_N.aln --tblout hmmer_$1_Spidroin_N.txt --cpu $NSLOTS /mnt/iusers01/sbc01/a73590hl/software/silkpipe/Spidroin_N.hmm bbmap_translate_$1_prot.fa

#grep trinity from hmmer
grep -v "#" hmmer_$1_Spidroin_N.txt | awk '{print $1}' | sort | uniq > matches_uniq_$1_Spidroin_N.txt
grep -v "#" hmmer_$1_Spidroin_MaSp.txt | awk '{print $1}' | sort | uniq > matches_uniq_$1_Spidroin_MaSp.txt
grep -v "#" hmmer_$1_RP1-2.txt | awk '{print $1}' | sort | uniq > matches_uniq_$1_RP1-2.txt

sort matches_uniq_$1_*.txt | uniq > all_3_hmm_matches_uniq_$1.txt
grep -A 1 -w --no-group-separator -f all_3_hmm_matches_uniq_$1.txt trinity_assembly_$1.Trinity.fasta > RNA_seq_match_$1.fasta

awk '/^>/ {printf("%s%s\t",(N>0?"\n":""),$0);N++;next;} {printf("%s",$0);} END {printf("\n");}'  RNA_seq_match_$1.fasta  |\
awk -F '\t' '{printf("%d\t%s\n",length($2),$0);}' |\
sort -k1,1nr | cut -f 2- | tr "\t" "\n" > RNA_seq_sorted_match_$1.fasta

#grep translated aa trinity from hmmer
grep -v "#" hmmer_$1_Spidroin_N.txt | awk '{print $1 " .*" $NF}' | sort | uniq > matches_aa_uniq_$1_Spidroin_N.txt
grep -v "#" hmmer_$1_Spidroin_MaSp.txt | awk '{print $1 " .*" $NF}' | sort | uniq > matches_aa_uniq_$1_Spidroin_MaSp.txt
grep -v "#" hmmer_$1_RP1-2.txt | awk '{print $1 " .*" $NF}' | sort | uniq > matches_aa_uniq_$1_RP1-2.txt

sort matches_aa_uniq_$1_*.txt | uniq > all_3_hmm_matches_aa_uniq_$1.txt
grep -A 1 -w --no-group-separator -f all_3_hmm_matches_aa_uniq_$1.txt bbmap_translate_$1_prot.fa > aa_seq_match_$1.fasta

awk '/^>/ {printf("%s%s\t",(N>0?"\n":""),$0);N++;next;} {printf("%s",$0);} END {printf("\n");}'  aa_seq_match_$1.fasta  |\
awk -F '\t' '{printf("%d\t%s\n",length($2),$0);}' |\
sort -k1,1nr | cut -f 2- | tr "\t" "\n" > aa_seq_sorted_match_$1.fasta