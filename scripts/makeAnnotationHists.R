#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly=TRUE)

DpFile <- args[1] # EMR_norm_bcf_DP.txt
HetFile <- args[2] # EMR_norm_bcf_ExcHet.txt
outFile <- args[3] # output file

dp <- read.csv(DpFile, sep = "\t", header= FALSE)
het <- read.csv(HetFile, sep = "\t", header= FALSE)


pdf(file = outFile, height = 6, width = 6)

# depth histogram

hist(dp[,3], main = "Histogram of DP", xlim = c(0,500), breaks = 1e5)
abline(v = median(dp[,3]), col = "black", lwd = 2)
mtext(round(median(dp[,3])), at = median(dp[,3]))

abline(v = (median(dp[,3])*1.5), col = "red", lwd = 2)
mtext(round(median(dp[,3])*1.5), at = (median(dp[,3])*1.5), col = "red")

abline(v = (median(dp[,3])*0.5), col = "red", lwd = 2)
mtext(round(median(dp[,3])*0.5), at = (median(dp[,3])*0.5), col = "red")

abline(v = (median(dp[,3])*0.75), col = "blue", lwd = 2)
mtext(round(median(dp[,3])*0.75), at = (median(dp[,3])*0.75), col = "blue")

abline(v = (median(dp[,3])*1.25), col = "blue", lwd = 2)
mtext(round(median(dp[,3])*1.25), at = (median(dp[,3])*1.25), col = "blue")

abline(v = (median(dp[,3])*2), col = "green", lwd = 2)
mtext(round(median(dp[,3])*2), at = (median(dp[,3])*2), col = "green")

legend("topright", c("+/- 0.5", "+/- 0.25", "x2"), col = c("red", "blue", "green"), lty = 1, lwd = 2)

print(paste0("Wow! I made a histogram from depth data "))
print(paste0("The median is ", median(dp[,3])))

# het histogram
het_vec <- na.omit(as.numeric(het[,3])) 
hist(het_vec, main = "Histogram of het")
abline(v = median(het_vec), col = "black", lwd = 2)
mtext(round(median(het_vec), digits = 3), at = median(het_vec))

abline(v = (median(het_vec)*0.5), col = "red", lwd = 2)
mtext(round(median(het_vec)*0.5, digits = 3), at = (median(het_vec)*0.5), col = "red")

abline(v = (median(het_vec)*0.75), col = "blue", lwd = 2)
mtext(round(median(het_vec)*0.75, digits = 3), at = (median(het_vec)*0.75), col = "blue")

legend("topleft", c("+/- 0.5", "+/- 0.25", "x2"), col = c("red", "blue", "green"), lty = 1, lwd = 2)

print(paste0("Wow! I made a histogram from het data ")) 

dev.off()
