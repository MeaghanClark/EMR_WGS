library(stringr)

# updated 8/29/24 for new reference genome

# load and process chromosome names
names <- read.csv("../rSisCat1_p1.0/ncbi_dataset/data/GCA_039880765.1/chrom_list.txt", header = FALSE)$V1

names <- str_remove(names, ">")

chrom_names <- unlist(lapply(X = strsplit(names, split = " "), FUN = function(x){x[1]}))[1:179]

# load chromosome lengths
lengths <- read.csv("../rSisCat1_p1.0/ncbi_dataset/data/GCA_039880765.1/chrom_lengths.txt", header = FALSE, sep = " ")
colnames(lengths) <- c("chrom_len", "chrom_name")

lengths$chrom_name == chrom_names

# make dataframe
# data <- cbind.data.frame(unlist(chrom_names), lengths)
# colnames(data) <- c("chrom_name", "chrom_len")
data <- lengths

# remove Z chromosome (CM078132.1) 
data <- data[-which(data$chrom_name == "CM078132.1"),]


total_length <- sum(data$chrom_len)

no_chunks <- 200 # define number of chunks to break the genome into 
chunk_length <- round(total_length / no_chunks)

# create order column
for(i in 1:nrow(data)){
  data$order[i] <- sum(data$chrom_len[1:i])
}

data$chrom_start <- c(1, data$order + 1)[1:nrow(data)]

data <- data[,c("chrom_name", "chrom_len", "chrom_start", "order")]

# Function to split the genome into segments
split_genome <- function(genome_df, num_segments = no_chunks) {
  
  # Calculate the total length of the genome
  total_genome_length <- sum(genome_df$chrom_len)
  
  # Calculate the length of each segment
  segment_length <- total_genome_length / num_segments
  
  # Initialize variables
  current_base_pair <- 1
  segments <- list()
  
  # Loop through each segment
  for (i in 1:num_segments) {
    # Initialize segment dataframe
    segment_df <- data.frame(chrom = character(), beg = integer(), end = integer())
    segment_df_index <- 1
    
    # Calculate segment boundaries
    segment_start <- current_base_pair
    segment_end <- current_base_pair + segment_length - 1
    
    # Loop through each chromosome to find segments that overlap with the current segment
    for (j in 1:nrow(genome_df)) {
      chrom_name <- genome_df$chrom_name[j]
      chrom_len <- genome_df$chrom_len[j]
      chrom_start <- genome_df$chrom_start[j]
      order <- genome_df$order[j]
      
      # Check if the chromosome overlaps with the current segment
      if (chrom_start <= segment_end && order >= segment_start) {
        # Calculate the start and end positions of the overlap in genome coordinates
        overlap_start_genome <- max(segment_start, chrom_start)
        overlap_end_genome <- min(segment_end, order)
        
        # Calculate the start and end positions within the chromosome
        overlap_start_chrom <- overlap_start_genome - chrom_start + 1
        overlap_end_chrom <- overlap_end_genome - chrom_start + 1
        
        # Add the overlap to the segment dataframe
        segment_df[segment_df_index, ] <- c(chrom_name, as.integer(overlap_start_chrom), as.integer(overlap_end_chrom))
        segment_df_index <- segment_df_index + 1
      }
    }
    
    # Add the segment dataframe to the list
    segments[[i]] <- segment_df
    
    # Update current base pair for the next segment
    current_base_pair <- segment_end + 1
  }
  
  return(segments)
}


# Example usage:
# Assuming your dataframe is named 'genome_df'
# Call the function to split the genome into segments
genome_segments <- split_genome(data)


# export each dataframe in genome_segments as a separate .txt file, labelled 1 through 50 "chrom_list_${ARRAY_NO}.txt"

for(i in 1:length(genome_segments)){
  write.table(genome_segments[[i]], file = paste0("../scripts/keys/chrom_200/chrom_list_", i, ".txt"), 
              row.names = FALSE, sep = "\t", 
              col.names = FALSE, 
              quote = FALSE, 
              fileEncoding="UTF-8")
}


# make scaffold files containing entire chromosomes/scaffolds for normalization 

# 1 through 20 get their own files
for(i in 1:20){
  line <- cbind.data.frame(data$chrom_name[i], 1, data$chrom_len[i])
  write.table(line, file = paste0("../scripts/keys/scaffolds/Scaf_", i, ".txt"), 
              row.names = FALSE, sep = "\t", 
              col.names = FALSE, 
              quote = FALSE, 
              fileEncoding="UTF-8")
}

# 21 through 178 get their own combined file

line <- cbind.data.frame(data$chrom_name[21:178], 1, data$chrom_len[21:178])
write.table(line, file = paste0("../scripts/keys/scaffolds/Scaf_21.txt"), 
            row.names = FALSE, sep = "\t", 
            col.names = FALSE, 
            quote = FALSE, 
            fileEncoding="UTF-8")










