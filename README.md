# SMS
Spidroin-Motif-Searcher
# Author
Leung Ho Kwan

# About
SMS is a fully functional pipeline, which performs *de novo* transcriptome assembly with the RNA-seq dataset of individual spider species, then searches the constructed transcripts to identify and catalogue putative spidroin sequences and repetitive motifs contained within.

# Input
(1) SRR accession number of transcriptome data from RNA-Seq  
  
(2) Profile Hidden Markov Models (profile HMMs) of conserved spidroin domains:   
* RP1-2.hmm  
* Spidroin_MaSp.hmm  
* Spidroin_N.hmm  

# To Run:

(1) Downloads the transcriptome data from NCBI database using the SRA accession number, then runs the *de novo* transcriptome assembly tool Trinity.  
`both_fastq-dump_trinity.sh SRR_accession_number`

(2) The transcriptome assembly is translated into amino acid sequences, to be used as input query sequences for HMMER to detect sequence homologs 
to known spidroin protein structures with the profile HMMs. The outputs should contain only putative spidroin sequences.  
`search_spidroin.sh SRR_accession_number`
  
(3) Queries the putative spidroin sequences with the repeat motif identification softwarre MEME.
The outputs are motif logos, alignment of motifs to the queried amino acid sequences, and the amino acid frequencies of the queried sequences.  
`meme_search.sh SRR_accession_number`

(4) Runs the reference-free evaluation methods DETONATE and TransRate on the transcriptome assembly.  
`qc.sh SRR_accession_number`
  
(5) Calculates the sequence coverage of the putative spidroin sequences by the RNA-seq reads, 
to visualize the number of reads matching each position in the assembled transcript in Rstudio.  
`get_coverage.sh SRR_accession_number`
