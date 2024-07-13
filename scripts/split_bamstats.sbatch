#!/bin/bash

# This script splits a whole-genome bamstats file into separate files based on chromosome coordinate files 

# Loop through each chrom_N.txt file
COORDINATE_FILE="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/chrom_200/chrom_list_${SLURM_ARRAY_TASK_ID}.txt"
OUTPUT_FILE="${OUTDIR}/EMR_ALL_qc_ordered_${SLURM_ARRAY_TASK_ID}.bamstats"

# Initialize the output file with header
HEADER=$(head -n 1 "$BIG_BAMSTATS")
echo -e "$HEADER" > "$OUTPUT_FILE"

# Read each line of the chrom file
while IFS=$'\t' read -r chr start end; do
    # Extract the lines from BAMSTATS_FILE that fall within the range
    awk -v chr="$chr" -v start="$start" -v end="$end" \
        '$1 == chr && $2 >= start && $2 <= end' "$BIG_BAMSTATS" >> "$OUTPUT_FILE"
done < "$COORDINATE_FILE"
