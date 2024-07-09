#!/bin/bash
########## SBATCH Lines for Resource Request ##########
#SBATCH --time=12:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=20G            # memory required per allocated CPU (or core)
#SBATCH --job-name=split_bamstats    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/split_bamstats/split_%A.out" 
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/split_bamstats/split_%A.err"
#SBATCH --account=bradburd
##########

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
