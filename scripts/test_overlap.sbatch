#!/bin/bash

# Running bam clipOverlap to determine how many reads are overlapping and how much is trimmed

# load modules, updated to ubuntu
module purge
module load BWA/0.7.17-20220923-GCCcore-12.3.0
module load SAMtools/1.18-GCC-12.3.0
module load powertools
module list


# define read files using ARRAY_KEY
line=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$ARRAY_KEY")
IFS=$'\t' read -r FORWARDREAD REVERSEREAD <<< "$line"
BASE=$(basename "$FORWARDREAD")
SAMPLE_NAME=$(echo "${BASE}" | cut -d "_" -f 1,2 | cut -d "." -f 2)

# trim overlap
bam clipOverlap --in ${SCRATCHNODE}/${SAMPLE_NAME}.rmdup.bam --overlapsOnly --stats --out ${OUTDIR}/${SAMPLE_NAME}.overlapping.bam 

wait

# done

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
