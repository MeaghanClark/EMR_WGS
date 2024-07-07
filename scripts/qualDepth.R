#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly=TRUE)

flist = args[1] #"/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_bamstats_depth.txt"
depth <- read.table(flist, head=TRUE)
#depth <- load(flist, verbose = T)

save(depth, file = args[2]) # "/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_bamstats_depth.Robj"

print("Before converting to numeric...")

str(depth)

head(depth)

dim(depth)

print(depth[1:10,])

outfile_hist = args[3]

depth <- as.numeric(depth[,1])

print("After converting to numeric...")
str(depth)

pdf(file = outfile_hist, height = 6, width = 6)
# total depth hist: ----------------------------------------------------------
#depth <- as.numeric(depth[,1])
hist(depth, main = NULL,  xlab = "depth")
abline(v = median(depth), col = "black", lwd = 2)
mtext(median(depth), at = median(depth))

abline(v = (median(depth)*1.5), col = "red", lwd = 2)
mtext((median(depth)*1.5), at = (median(depth)*1.5), col = "red")

abline(v = (median(depth)*0.5), col = "red", lwd = 2)
mtext((median(depth)*0.5), at = (median(depth)*0.5), col = "red")

abline(v = (median(depth)*0.75), col = "blue", lwd = 2)
mtext((median(depth)*0.75), at = (median(depth)*0.75), col = "blue", line = 1.5)

abline(v = (median(depth)*1.25), col = "blue", lwd = 2)
mtext((median(depth)*1.25), at = (median(depth)*1.25), col = "blue", line = 1.5)

abline(v = (median(depth)*2), col = "green", lwd = 2)
mtext((median(depth)*2), at = (median(depth)*2), col = "green")

legend("topright", c("+/- 0.5", "+/- 0.25", "x2"), col = c("red", "blue", "green"), lty = 1, lwd = 2)

### zoom 1 ----------------------------------------------------------
hist(depth, main = NULL, xlim = c(0, 6000), xlab = "depth", breaks = 100000)
abline(v = median(depth), col = "black", lwd = 2)
mtext(median(depth), at = median(depth))

abline(v = (median(depth)*1.5), col = "red", lwd = 2)
mtext((median(depth)*1.5), at = (median(depth)*1.5), col = "red")

abline(v = (median(depth)*0.5), col = "red", lwd = 2)
mtext((median(depth)*0.5), at = (median(depth)*0.5), col = "red")

abline(v = (median(depth)*0.75), col = "blue", lwd = 2)
mtext((median(depth)*0.75), at = (median(depth)*0.75), col = "blue")

abline(v = (median(depth)*1.25), col = "blue", lwd = 2)
mtext((median(depth)*1.25), at = (median(depth)*1.25), col = "blue")

abline(v = (median(depth)*2), col = "green", lwd = 2)
mtext((median(depth)*2), at = (median(depth)*2), col = "green")

legend("topright", c("+/- 0.5", "+/- 0.25", "x2"), col = c("red", "blue", "green"), lty = 1, lwd = 2)

dev.off()
