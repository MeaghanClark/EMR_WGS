#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly=TRUE)

fileName <- args[1] # Bamstats file testing: "/Users/meaghan/Desktop/EMR_WGS/bamstats_test.txt"
outFile <- args[2] # outfile testing: "/Users/meaghan/Desktop/EMR_WGS/hist_test.pdf"
data <- read.csv(fileName, sep = "\t", header= TRUE)

pdf(file = outFile, height = 6, width = 6)
for(i in c(3:9)){
  hist(data[,i], main = paste0("Histogram of ", colnames(data)[i]))
}
dev.off()

