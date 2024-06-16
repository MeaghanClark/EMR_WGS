#!/bin/bash

# zip_fastq.sbatch
# This script runs zips fastq files 
# Last updated 06/16/2024 by MI Clark, script format inspired by R Toczydlowski 

#--------------- EXECUTABLE ---------------

# define SEQFILE using ARRAY_KEY
SEQFILE=$(awk -v row=1 'NR==row{print ${SLURM_ARRAY_TASK_ID}}' $ARRAY_KEY | tr -d '\r') # I think something is wrong here

echo SEQFILE defined as $SEQFILE

# run fastQC
bgzip $SEQFILE --stdout > ${OUTDIR}/${SEQFILE}.fastq.gz

wait

echo bgzip run on $SEQFILE and output stored in $OUTDIR

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------

