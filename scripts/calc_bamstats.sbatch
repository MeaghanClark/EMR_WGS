#!/bin/bash

#--------------- EXECUTABLE ---------------

# This script runs bamstats on a merged bam file
# Last updated 06/24/2023 by MI Clark,based on script by T Linderoth
# Input: 
#
# Output: 

#load programs we want to use, updated to ubuntu
module purge
module load powertools
module load BCFtools/1.19-GCC-13.2.0
module list 

bcftools --version

# define array vars
CHROMLIST="${CHROM_LIST_DIR}/chrom_list_${SLURM_ARRAY_TASK_ID}.txt" # path to list of chromosomes

OUTFILE=${OUTDIR}/EMR_all_qc.${SLURM_ARRAY_TASK_ID}.bamstats 

# run bamstats
while read -r CHROM
do
        CMD="$BAMSTATS -A -d 0 -f $REFERENCE -q 0 -Q 0 -r $CHROM --ff UNMAP,SECONDARY,QCFAIL,DUP -s -aa $INBAM >> $OUTFILE"
        printf "\n%s\n\n" "$CMD"
        eval $CMD
        wait
done < $CHROMLIST
wait

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
