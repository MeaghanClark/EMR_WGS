#!/bin/bash

# This script splits a whole-genome bcf file into separate files based on chromosome coordinate files 

# load modules 
module purge
module load powertools
module load BCFtools/1.19-GCC-13.2.0
module list

# importing: OUTDIR=$outdir,CPUS=$cpus,BIG_BCF=$big_bcf,LOGFILESDIR=$logfilesdir,DATE=$date,CHROM_LIST_DIR=$chrom_list_dir \

# Input files
echo splitting ${BIG_BCF}

CHUNK_FILE=${CHROM_LIST_DIR}/scaf_list_${SLURM_ARRAY_TASK_ID}.txt

# Read the coordinate file line by line
# Define the output file name
OUTPUT_FILE="${OUTDIR}/EMR_WGS_drop_norm_${SLURM_ARRAY_TASK_ID}.bcf.gz"

SCAF=$(cat $CHUNK_FILE)

# Extract the region from the BCF file
CMD="bcftools view -r $SCAF -o $OUTPUT_FILE -O b $BIG_BCF"
printf "\n%s\n\n" "$CMD"
eval $CMD
wait

module purge
module load tabixpp/1.1.2-GCC-12.3.0
module list

# CHANGE FILE NAME
tabix -p bcf ${OUTDIR}/EMR_WGS_drop_norm_${SLURM_ARRAY_TASK_ID}.bcf.gz

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------

