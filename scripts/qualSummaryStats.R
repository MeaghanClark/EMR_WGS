#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly=TRUE)
if (length(args) < 1) {
        cat("\nqualSummaryStats.R <list of files with quality values (one file per row)> <outfile name> [column numbers to analyze]\n\n")
        options(show.error.messages=FALSE)
        stop()
}

flist <- as.character(read.table(args[1], head=FALSE)$V1) # list of file name 
#flist <- "/Users/meaghan/Desktop/EMR_WGS/variants/bamstats_TEST.txt" # delete! 
outname_sum <- args[2] 
outfile_hist <- args[3]
subidx <- NULL
if (length(args) > 1) subidx = as.numeric(args[4:length(args)]) 
#subidx = c(3, 4, 5, 6, 7, 8, 9)  # delete! 

df <- NULL
fheader <- read.table(flist[1],head=TRUE,nrows=1)
classes <- NULL
if (is.null(subidx)) classes <- "character" else classes <- sapply(1:ncol(fheader),function(x,idx){ifelse(x %in% idx,"character","NULL")},idx=subidx)

for (infile in flist) {
	cat(paste0("Merging ", infile, "\n"))
	df <- rbind(df, read.table(infile, head=TRUE, na.strings=".", colClasses=classes))
}

df.stats <- data.frame(stat=colnames(df))
df.stats$mean = sapply(1:ncol(df),function(x,val){mean(as.numeric(val[,x]), na.rm=TRUE)}, val=df)
df.stats$median = sapply(1:ncol(df),function(x,val){median(as.numeric(val[,x]), na.rm=TRUE)}, val=df)
df.stats$var = sapply(1:ncol(df),function(x,val){var(as.numeric(val[,x]), na.rm=TRUE)}, val=df)
df.stats$percentile_1 = sapply(1:ncol(df),function(x,val){quantile(as.numeric(val[,x]), 0.01, na.rm=TRUE)}, val=df)
df.stats$percentile_2 = sapply(1:ncol(df),function(x,val){quantile(as.numeric(val[,x]), 0.02, na.rm=TRUE)}, val=df)
df.stats$percentile_3 = sapply(1:ncol(df),function(x,val){quantile(as.numeric(val[,x]), 0.03, na.rm=TRUE)}, val=df)
df.stats$percentile_5 = sapply(1:ncol(df),function(x,val){quantile(as.numeric(val[,x]), 0.05, na.rm=TRUE)}, val=df)
df.stats$percentile_95 = sapply(1:ncol(df),function(x,val){quantile(as.numeric(val[,x]), 0.95, na.rm=TRUE)}, val=df)
df.stats$percentile_97 = sapply(1:ncol(df),function(x,val){quantile(as.numeric(val[,x]), 0.97, na.rm=TRUE)}, val=df)
df.stats$percentile_98 = sapply(1:ncol(df),function(x,val){quantile(as.numeric(val[,x]), 0.98, na.rm=TRUE)}, val=df)
df.stats$percentile_99 = sapply(1:ncol(df),function(x,val){quantile(as.numeric(val[,x]), 0.99, na.rm=TRUE)}, val=df)

write.table(df.stats,file=outname_sum,col.names=TRUE,row.names=FALSE,sep="\t",quote=FALSE)

cat("Finished with text output summary\n")

cat("starting to make some histograms...\n")

pdf(file = outfile_hist, height = 6, width = 6)
# total depth hist: 
depth <- as.numeric(df[,1])
hist(depth, main = NULL,  xlab = colnames(df)[1])
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
  

### zoomed in depth ----------------------------------------------------------
hist(depth, main = NULL, xlim = c(0, 12000), xlab = "depth", breaks = 100000)
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


# other stats
for(i in c(2:ncol(df))){
    hist(na.omit(as.numeric(df[,i])), main = NULL, xlab = colnames(df)[i])
    print(paste0("Wow! I made a histogram from column ", i)) 
}
  
dev.off()






