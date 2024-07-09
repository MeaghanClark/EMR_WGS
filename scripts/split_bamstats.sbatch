#!/bin/bash

# This script splits a whole-genome bamstats file into separate files based on chromosome coordinate files 
# Input files
BAMSTATS_FILE="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_ALL_qc_ordered.bamstats"

# Output directory
OUTPUT_DIR="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/chrom_bamstats"

# Loop through each chrom_N.txt file
for N in {2..200}; do
    COORDINATE_FILE="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/chrom_200/chrom_list_${N}.txt"
    OUTPUT_FILE="${OUTPUT_DIR}/EMR_ALL_qc_ordered_${N}.bamstats"

    # Initialize the output file
    > "$OUTPUT_FILE"

    # Read each line of the coordinate file
    while IFS=$'\t' read -r chr start end; do
        # Extract the lines from BAMSTATS_FILE that fall within the range
        awk -v chr="$chr" -v start="$start" -v end="$end" \
            '$1 == chr && $2 >= start && $2 <= end' "$BAMSTATS_FILE" >> "$OUTPUT_FILE"
    done < "$COORDINATE_FILE"
done
