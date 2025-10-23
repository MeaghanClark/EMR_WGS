#!/usr/bin/env Rscript

## File name: processROH.R
## Purpose: Process ROH output lines from bcftools ROH
## M. I. Clark, October 2025
  # based on rohRegions.pl script by T. Linderoth
## Last updated: 10/10/2025

# Set default minimum site quality for FROH estimation
minq=20
# Set minimum length threshold 
threshold <- 1e5

# Capture args
args <- commandArgs(trailingOnly = TRUE)

# If no arguments or fewer than 2 are provided, print usage message and stop
if (length(args) < 2) {
  stop("Usage: Rscript processROH.R <bcftools_roh_file.txt> <output_file.regions> [min_quality] [length_threshold]")
}

# Output and input filenames are the first two arguments
infile <- args[1]
outfile <- args[2]

# Update optional arguments from defaults if provided
# If a third argument is provided, override default min quality
minq <- ifelse(length(args) >= 3, as.numeric(args[3]), minq)
# If a fourth argument is provided, override default minimum length threshold
threshold <- ifelse(length(args) >= 4, as.numeric(args[4]), threshold)

# Read input file, or die if fails
lines <- readLines(infile)
lines <- lines[grepl("^ROH", lines)]

if (length(lines) == 0) stop("No ROH lines found in input file.")

# convert to dataframe
df <- do.call(rbind, lapply(X = lines, FUN = function(z){unlist(strsplit(x = z, split = "\t"))}))
df <- data.frame(scaff <- df[,3], 
                 position <- as.integer(df[,4]), 
                 is_autozygous <- as.integer(df[,5]),
                 quality <- as.numeric(df[,6]), 
                 stringsAsFactors = FALSE)
colnames(df) <- c("scaff", "position", "is_autozygous", "quality")


# Initialize counters and state-tracking variables
nsites <- 0
nsites_hiq <- 0
nauto <- 0
nauto_hiq <- 0
prevstate <- 0
rohlen <- 0
avgq <- 0
prevscaff <- ""

# ROH region list: scaffold, start, end, quality, number of SNPs in ROH region
reg <- list(scaffold="", start=0, end=0, qual=0, sites=0, hq_sites=0)

# ROH output
roh_list <- list()

# Process input line by line
for(i in 1:nrow(df)){
  row <- df[i,]
  # new scaffold
  if(row$scaff != prevscaff){ # new scaffold! 
    # If we ended the last scaffold within a ROH region, finalize and write it
    if(prevstate == 1){
      rohlen = reg$end - reg$start + 1
      avgq <- reg$qual / reg$sites
      # save ROH region
      roh_list[[length(roh_list)+1]] <- c(reg$scaffold, reg$start, reg$end, rohlen, avgq, reg$sites, reg$hq_sites)
      # reset region list
      reg <- list(scaffold="", start=0, end=0, qual=0, sites=0, hq_sites=0)
      # clear previous state
      prevstate = 0
    }
  }
    
    # new state is autozygous
    if(row$is_autozygous == 1){
      nauto <- nauto + 1
      if(row$quality >= minq) nauto_hiq <- nauto_hiq + 1
      
      if(prevstate == 0){
        # new ROH region
        reg$scaffold <- row$scaff
        reg$start <- row$position
        reg$end <- row$position
        reg$qual <- row$quality
        reg$sites <- 1
        reg$hq_sites <- ifelse(row$quality >= minq, 1, 0)

      }else {
        # continuing ROH region
        reg$end <- row$position # update end position
        reg$qual <- reg$qual + row$quality
        reg$sites <- reg$sites + 1
        reg$hq_sites <- ifelse(row$quality >= minq, reg$hq_sites + 1, reg$hq_sites)
      }
    } else { 
      # new site is not autozygous
      if(prevstate == 1){
        # end of ROH region
        rohlen <- reg$end - reg$start + 1 # is the +1 needed? 
        avgq <- reg$qual / reg$sites
        # save ROH region
        roh_list[[length(roh_list)+1]] <- c(reg$scaffold, reg$start, reg$end, rohlen, avgq, reg$sites, reg$hq_sites)
        # reset region list
        reg <- list(scaffold="", start=0, end=0, qual=0, sites=0, hq_sites=0)
      }
    }
    nsites <- nsites + 1
    if(row$quality >= minq) nsites_hiq <- nsites_hiq + 1
    prevstate <- row$is_autozygous
    prevscaff <- row$scaff
}

# Handle final ROH region if input ends inside a ROH
if(prevstate == 1){
  rohlen <- reg$end - reg$start + 1
  avgq <- reg$qual / reg$sites
  # save ROH region
  roh_list[[length(roh_list)+1]] <- c(reg$scaffold, reg$start, reg$end, rohlen, avgq, reg$sites, reg$hq_sites)
  
}

roh_df <- do.call(rbind, roh_list) # coerces to string... must be a better way to do this
roh_df <- data.frame(
              scaffold = roh_df[,1],
              start = as.integer(roh_df[,2]),
              end = as.integer(roh_df[,3]),
              length = as.integer(roh_df[,4]),
              avg_qual = as.numeric(roh_df[,5]),
              sites = as.integer(roh_df[,6]),
              hq_sites = as.integer(roh_df[,7]),
              stringsAsFactors = FALSE)
# Save output table

write.table(roh_df, file=outfile, sep="\t", quote=FALSE, row.names=FALSE)

# Calculate FROH (fraction of genome autozygous)
pauto <- if (nsites > 0) sprintf("%.8f", nauto / nsites) else "NaN"
pauto_hiq <- if (nsites_hiq > 0) sprintf("%.8f", nauto_hiq / nsites_hiq) else "NaN"

# Calculate FROH with size limitation 
pauto_threshold <- if(nsites > 0) sprintf("%.8f", sum(roh_df[roh_df$length > threshold,"sites"]) / nsites) else "NaN"
pauto_threshold_hq <- if(nsites_hiq > 0) sprintf("%.8f", sum(roh_df[roh_df$length > threshold,"hq_sites"]) / nsites_hiq) else "NaN"

# Print summary statistics to STDOUT
cat("FROH\tFROH_HIQUAL\tTHRESHOLD\tFROH_THRESHOLD\tFROH_THRESHOLD_HIQUAL\tN_SITES\tN_AUTOZYGOUS\tN_SITES_HIQUAL\tN_AUTOZYGOUS_HIQUAL\n")
cat(paste(pauto, pauto_hiq, threshold, pauto_threshold, pauto_threshold_hq, nsites, nauto, nsites_hiq, nauto_hiq, sep="\t"), "\n")

# DONE














