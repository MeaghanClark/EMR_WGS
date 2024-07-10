#!/bin/bash

# This script splits a whole-genome bamstats file into separate files based on chromosome coordinate files 

# Loop through each chrom_N.txt file
echo using $CHROM_FILE to speed up job $I

read -r CHR START END <<< $(awk -v row=${SLURM_ARRAY_TASK_ID} -F',' 'NR==row {print $1, $2, $3}' "$CHROM_FILE" | tr -d '\r')


OUTPUT_FILE="${OUTPUT_DIR}/EMR_ALL_qc_ordered_${I}_${SLURM_ARRAY_TASK_ID}.bamstats"

# Initialize the output file with header
HEADER=$(head -n 1 "$BIG_BAMSTATS")
echo -e "$HEADER" > "$OUTPUT_FILE"

# Extract the lines from BAMSTATS_FILE that fall within the range
awk -v chr="$CHR" -v start="$START" -v end="$END" \
    '$1 == chr && $2 >= start && $2 <= end' "$BIG_BAMSTATS" >> "$OUTPUT_FILE"

echo done! 
