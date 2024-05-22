# ROH visualization
# M. Clark
# 9/7/2022

# based on advice from: https://github.com/samtools/bcftools/issues/1476

library(chromoMap)
library(scales)

# chromosome file 

# c("chrom_name", "chrom_start", "chrom_end")
ref = "../ROH/Scatenatus_HiC_v1.1.fasta.fai"
ref_index <- read.table(ref, sep = "\t")
colnames(ref_index) <- c("name", "length", "offset", "linebases", "linewidth")

chrom_chart <- cbind.data.frame(ref_index$name, rep(1, nrow(ref_index)), ref_index$length)
colnames(chrom_chart) <- c("name", "start", "end")

# annotation files
roh = "../ROH/RG_lines.txt"

# c("element_name", "chromosome_name", "element_start", "element_end")
roh_df <- read.csv(roh, sep = "\t")
colnames(roh_df) <- c("RG", "sample", "chromosome", "start", "end", "length_bp", "no_of_markers", "avg_phred")

roh_df$site <- NA
roh_df[grepl("ELF", roh_df$sample),"site"] <- "ELF"
roh_df[grepl("PCC", roh_df$sample),"site"] <- "PCC"


#samples <- lapply(1:nrow(roh_df), FUN=function(x){strsplit(roh_df$X.2.Sample, "/")[[x]][[8]]})
#samples <- unlist(samples)
#roh_df$sample <- samples

# prep chromomap
annotations <- cbind.data.frame(1:nrow(roh_df), roh_df$chromosome, roh_df$start, roh_df$end)
colnames(annotations) <- c("ID", "chromosome", "start", "end")

# make chromomap
roh_chrom <- chrom_chart[1:3,]

chromoMap(list(roh_chrom), list(annotations))

# length of ROH
hist(roh_df$length_bp, main = "EMR runs of homozygosity", xlab = "length in bp")

range(roh_df$length_bp)

unique_samples_long <- unique(roh_df$sample)
unique_samples_short <- unlist(lapply(1:length(unique_samples_long), FUN=function(x){strsplit(strsplit(unique_samples_long, "/")[[x]][[8]], "[.]")[[1]][1]}))

ELF_roh_df <- roh_df[grepl("ELF", roh_df$sample),]
PCC_roh_df <- roh_df[grepl("PCC", roh_df$sample),]

hist(ELF_roh_df$length_bp)
hist(PCC_roh_df$length_bp)

dim(ELF_roh_df)
dim(PCC_roh_df)

pdf(file = "../ROH/site_roh_hist.pdf", width = 10, height = 6)
par(mfrow = c(1,2))
boxplot(roh_df$length_bp~roh_df$site, xlab = "site", ylab = "ROH length in bp", col = c("mediumpurple", "steelblue"))

boxplot(roh_df$length_bp~roh_df$sample, xlab = "individual", ylab = "ROH length in bp", names = NULL, col = c(rep("mediumpurple", 5), rep("steelblue", 5)))
dev.off()

## per ind
roh_list <- lapply(1:length(unique_samples_long), FUN = function(x) {roh_df[which(roh_df$sample == unique_samples_long[x]),]})

pdf(file = "../ROH/ind_roh_hist.pdf", width = 10, height = 6)
par(mfrow = c(2,5))
for(i in 1:length(unique_samples_long)){
  hist(roh_list[[i]]$length_bp, xlim = c(0, 7e5), main = unique_samples_short[i], 
       xlab = ("length in bp"))
}

dev.off()

# number vs length
std <- function(x){sd(x)/sqrt(length(x))}

pdf(file = "../ROH/roh_num_v_length.pdf", width = 6, height = 6)
par(mfrow = c(1,1))
plot(NULL, xlim = c(2200, 3300), ylim = c(0, 6e4), 
     xlab = "number of ROH", 
     ylab = "length of ROH")
for(i in 1:5){
  points(x = nrow(roh_list[[i]]), y = mean(roh_list[[i]]$length_bp), pch = 19, col = alpha("mediumpurple", alpha = 1), cex = 1)
  segments(x0 = nrow(roh_list[[i]]), x1 = nrow(roh_list[[i]]), y0 = (mean(roh_list[[i]]$length_bp) - std(roh_list[[i]]$length_bp)), y1 = (mean(roh_list[[i]]$length_bp) + std(roh_list[[i]]$length_bp)) )
}
for(i in 6:10){
  points(x = nrow(roh_list[[i]]), y = mean(roh_list[[i]]$length_bp), pch = 19, col = alpha("steelblue", alpha = 1), cex = 1)
  segments(x0 = nrow(roh_list[[i]]), x1 = nrow(roh_list[[i]]), y0 = (mean(roh_list[[i]]$length_bp) - std(roh_list[[i]]$length_bp)), y1 = (mean(roh_list[[i]]$length_bp) + std(roh_list[[i]]$length_bp)) )
}
legend("bottomright", legend = c("ELF", "PCCI", "standard error"), col = c("mediumpurple", "steelblue", "black"), lwd = 1, lty = c(NA, NA, 1), pch = c(19, 19, NA), merge = FALSE)

dev.off()

##### 
strsplit(strsplit(unique_samples, "/")[[x]][[8]], ".")

strsplit("ELF_321_L3.rmdup.bam", "[.]")[[1]][1]
