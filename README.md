# SMS
Spidroin-Motif-Searcher
# Author
Leung Ho Kwan

# Input
(1) Transcriptome data from RNA-Seq  
  
(2) Profile Hidden Markov Models (profile HMMs) of conserved spidroin domains:   
RP1-2.hmm  
Spidroin_MaSp.hmm  
Spidroin_N.hmm  

# To Run:

(1) both_fastq-dump_trinity.sh  
Downloads the transcriptome data from NCBI database using the SRA accession number, then runs the de novo transcriptome assembly tool Trinity.  
  
(2) search_spidroin.sh  
The transcriptome assembly is translated into amino acid sequences, to be used as input query sequences for HMMER to detect sequence homologs 
to known spidroin protein structures with the profile HMMs. The outputs should contain only putative spidroin sequences.  
  
(3) meme_search.sh  
Queries the putative spidroin sequences with the repeat motif identification softwarre MEME.
The outputs are motif logos, alignment of motifs to the queried amino acid sequences, and the amino acid frequencies of the queried sequences.  
  
(4) qc.sh  
Runs the reference-free evaluation methods DETONATE and TransRate on the transcriptome assembly.

(5) get_coverage.sh  
Calculates the sequence coverage of the putative spidroin sequences by the RNA-seq reads, 
to visualize the number of reads matching each position in the assembled transcript in Rstudio.
