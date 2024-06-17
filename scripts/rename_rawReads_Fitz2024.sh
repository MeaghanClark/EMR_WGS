#!/bin/bash

# Path to the directory containing the files
FILE_DIR="/mnt/scratch/clarkm89/EMR_WGS/fastqs_10686-MC"
# Path to the ID mapping file
ID_MAPPING_FILE="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/newWGS_ids.txt"

while read initialID finalID; do
	for file in "$FILE_DIR"/"$initialID"_*; do
        # Extract the forward/reverse read info from the filename
        importantinfo=$(echo "$file" | sed 's/.*_R\([[:digit:]]\)_001.fastq.gz/\1/')
        # Construct the new filename
        echo $file
        echo $importantinfo
        newfile="${FILE_DIR}/${finalID}_${importantinfo}.fastq.gz"
        echo $newfile
        echo #####
		#mv "$file" "$newfile"
	done
done < "$ID_MAPPING_FILE"



