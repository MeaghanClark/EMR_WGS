#!/bin/bash

# Fitz 2021 genomes
# Path to the directory containing the files
FILE_DIR="/mnt/scratch/clarkm89/EMR_WGS_2020_RawData/rawData"
# Path to the ID mapping file

while read file; do
	#for file in "$FILE_DIR"/"$initialID"_*; do
		echo $file
        # Extract the forward/reverse read info from the filename
        importantinfo=$(echo "$file" | sed 's/.*_\([[:digit:]]\).fq.gz/\1/')
        # Construct the new filename
        finalID=$(echo $file | sed -E 's/^([A-Z_]+[0-9]+).*/\1/')
        newfile="${FILE_DIR}/${finalID}_${importantinfo}.fastq.gz"
	 mv "${FILE_DIR}/${file}" "${newfile}"
	#done
done < "${FILE_DIR}/files.txt"



