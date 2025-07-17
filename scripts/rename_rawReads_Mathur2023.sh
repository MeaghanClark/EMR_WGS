#!/bin/bash


# Mathur_etal_2023 genomes
# Path to the directory containing the files
FILE_DIR="/mnt/scratch/clarkm89/EMR_WGS_Mathur2023"
# Path to the ID mapping file
ID_MAPPING_FILE="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/Mathur2023_ids.txt"


while read initialID finalID; do
	for file in "$FILE_DIR"/"$initialID"_*; do
        # Extract the forward/reverse read info from the filename
        importantinfo=$(echo "$file" | sed 's/.*_\([[:digit:]]\).fastq.gz/\1/')
        # Construct the new filename
        newfile="${FILE_DIR}/${finalID}_${importantinfo}.fastq.gz"
		mv "$file" "$newfile"
	done
done < "$ID_MAPPING_FILE"



