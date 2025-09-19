#!/bin/bash --login

# This script merges bam files 
# Last updated 08/26/2024 by MI Clark,based on script by T Linderoth
# Input: Reference genome with path, list of bamfiles
#
# Output: merged BAM file for individuals sequenced twice

#load programs we want to use
module purge
module load SAMtools/1.18-GCC-12.3.0
module load powertools
module list 

# define sample name and bams to merge from array key 

line=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$ARRAY_KEY")

IFS=$'\t' read -r BAM1 BAM2 <<< "$line"
BASE=$(basename "$BAM1")
SAMPLE_NAME=$(echo "${BASE}" | cut -d "." -f 1)

# define output file
OUTFILE=${OUTDIR}/${SAMPLE_NAME}.trim.merge.bam 

# define command
CMD="samtools merge -o ${OUTFILE} -O BAM --reference $REF -@ $CPUS $BAM1 $BAM2"

# run command 
printf "\n%s\n\n" "$CMD"

eval $CMD

wait

INDEX_CMD="samtools index -@ $CPUS ${OUTFILE}"

printf "\n%s\n\n" "$INDEX_CMD"

eval $INDEX_CMD

printf "\n--FIN--\n"


#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
