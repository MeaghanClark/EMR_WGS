#!/bin/bash

# zip_fastq.sbatch
# This script runs zips fastq files 
# Last updated 06/16/2024 by MI Clark, script format inspired by R Toczydlowski 

#--------------- EXECUTABLE ---------------

# define SEQFILE using ARRAY_KEY
SEQFILE=$(awk -v row="${SLURM_ARRAY_TASK_ID}" 'NR==row {print $0}' $ARRAY_KEY | tr -d '\r')

echo SEQFILE defined as $SEQFILE

# run bgzip
bgzip $SEQFILE --stdout > ${SEQFILE}.gz

wait

echo bgzip run on $SEQFILE and output stored in $OUTDIR

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------

