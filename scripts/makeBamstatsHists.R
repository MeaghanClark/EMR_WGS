#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly=TRUE)

fileName <- args[1] # Bamstats file testing: "/Users/meaghan/Desktop/EMR_WGS/bamstats_test.txt"
outFile <- args[2] # outfile testing: "/Users/meaghan/Desktop/EMR_WGS/hist_test.pdf"
data <- read.csv(fileName, sep = "\t", header= TRUE)

pdf(file = outFile, height = 6, width = 6)
for(i in c(3:9)){
  if(i == 3){
    hist(data[,i], main = paste0("Histogram of ", colnames(data)[i]), xlim = c(0, 500), breaks = 1e5)
    abline(v = median(data[,i]), col = "black", lwd = 2)
    mtext(median(data[,i]), at = median(data[,i]))
    
    abline(v = (median(data[,i])*1.5), col = "red", lwd = 2)
    mtext((median(data[,i])*1.5), at = (median(data[,i])*1.5), col = "red")
  
    abline(v = (median(data[,i])*0.5), col = "red", lwd = 2)
    mtext((median(data[,i])*0.5), at = (median(data[,i])*0.5), col = "red")
    
    abline(v = (median(data[,i])*0.75), col = "blue", lwd = 2)
    mtext((median(data[,i])*0.75), at = (median(data[,i])*0.75), col = "blue")
    
    abline(v = (median(data[,i])*1.25), col = "blue", lwd = 2)
    mtext((median(data[,i])*1.25), at = (median(data[,i])*1.25), col = "blue")
    
    abline(v = (median(data[,i])*2), col = "green", lwd = 2)
    mtext((median(data[,i])*2), at = (median(data[,i])*2), col = "")
    
    legend("topright", c("+/- 0.5", "+/- 0.25", "x2"), col = c("red", "blue", "green"), lty = 1, lwd = 2)
    
    print(paste0("Wow! I made a histogram from column ", i))
    print(paste0("The median is ", median(data[,i])))
    
          }else{
            hist(na.omit(as.numeric(data[,i])), main = paste0("Histogram of ", colnames(data)[i]))
            print(paste0("Wow! I made a histogram from column ", i)) 
          }
  }
dev.off()