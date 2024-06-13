library(stringr)

# load and process chromosome names
names <- read.csv("../scaf_names.txt", header=FALSE)$V1

names <- str_remove(names, ">")

chrom_names <- str_split(names, " ")

for(i in 1:length(chrom_names)){
  if(length(chrom_names[[i]] > 1)){
    chrom_names[[i]] <- chrom_names[[i]][1]
  }
}

# load chromosome lengths
lengths <- read.csv("../scaf_lengths.txt", header = FALSE)

# make dataframe
data <- cbind.data.frame(unlist(chrom_names), lengths)
colnames(data) <- c("chrom_name", "chrom_len")


total_length <- sum(data$chrom_len)

no_chunks <- 50 # define number of chunks to break the genome into 
chunk_length <- round(total_length / no_chunks)

# create order column
for(i in 1:nrow(data)){
  data$order[i] <- sum(data$chrom_len[1:i])
}

data$chrom_start <- c(1, data$order + 1)[1:nrow(data)]

data <- data[,c("chrom_name", "chrom_len", "chrom_start", "order")]

# Function to split the genome into segments
split_genome <- function(genome_df, num_segments = 50) {
  
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
    segment_df <- data.frame(CHROM = character(), BEG = integer(), END = integer())
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
        # Calculate the start and end positions of the overlap
        overlap_start <- max(segment_start, chrom_start)
        overlap_end <- min(segment_end, order)
        
        # Add the overlap to the segment dataframe
        segment_df[segment_df_index, ] <- c(chrom_name, as.integer(overlap_start), as.integer(overlap_end))
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

# Now genome_segments is a list where each entry contains a dataframe with chromosome name,
# starting and ending base pairs for that chromosome segment that make up the genome segment.


# export each dataframe in genome_segments as a separate .txt file, labelled 1 through 50 "chrom_list_${ARRAY_NO}.txt"

for(i in 1:length(genome_segments)){
  write.table(genome_segments[[i]], file = paste0("../scripts/keys/chrom/chrom_list_", i, ".txt"), row.names = FALSE, sep = "\t")
}

