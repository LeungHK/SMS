#setwd()

#read fastq1 and fastq2 files in txt format with read.csv
#change $1 to SRR accession
SRR = "SRRXXXXXXX"
results<-read.csv(paste0("magicblast_query_spidroin_RNA_fastq1_", SRR, "_tabular.txt"), header = T, sep = "\t")
#results<-read.csv("magicblast_query_spidroin_RNA_fastq1_$1_tabular.txt", header = T, sep = "\t")
results_right2<-read.csv(paste0("magicblast_query_spidroin_RNA_fastq2_", SRR, "_tabular.txt"), header = T, sep = "\t")
#results_right2<-read.csv("magicblast_query_spidroin_RNA_fastq2_$1_tabular.txt", header = T, sep = "\t")

#install.packages('seqinr')
library(seqinr)
#read FASTA file
name_list_seq_length <- read.fasta(paste0("RNA_seq_sorted_match_", SRR, ".fasta"), 
                                   seqtype = c("DNA"), as.string = FALSE, forceDNAtolower = TRUE,
                                   set.attributes = TRUE, legacy.mode = TRUE, seqonly = FALSE, strip.desc = FALSE,
                                   whole.header = FALSE,
                                   bfa = FALSE, sizeof.longlong = .Machine$sizeof.longlong,
                                   endian = .Platform$endian, apply.mask = TRUE)

#plot sequence coverage graphs for first 30 sequences
cl <- rainbow(30)
for(k in 1:30) {
  Name_target = getName(name_list_seq_length[[k]])
  jpeg(paste0("Plot_of_", Name_target,".jpg"), width = 600, height = 600)
  length_of_seq = summary(name_list_seq_length[[k]])$length  # length of k sequence
  seq1 <- subset(results, results$reference.acc. == Name_target)
  seq2 <- subset(results_right2, results_right2$reference.acc. == Name_target)
  data_set=rep(0, length_of_seq)
  if (nrow(seq1)!=0){
    for(i in 1:nrow(seq1)) {
      for(j in seq1$reference.start[i]:seq1$reference.end[i]){
        data_set[j]=data_set[j]+1
      }
    }
  }
  if (nrow(seq2)!=0){
    for(m in 1:nrow(seq2)) {
      for(n in seq2$reference.start[m]:seq2$reference.end[m]){
        data_set[n]=data_set[n]+1
      }
    }
  }
  x_axis=1:length_of_seq
  plot(x_axis, data_set, col=cl[k], type = "l", xlab="Sequence", ylab="Coverage", cex.lab=1.5, cex.axis=1.5, lwd=3)
  print(data_set[(length(data_set)-20):length(data_set)])
  dev.off()
}
