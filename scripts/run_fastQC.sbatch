#!/bin/bash

# run_fastQC.sbatch
# This script runs fastQC on raw sequencing reads in parallel 
# Last updated 05/16/2024 by MI Clark, script format inspired by R Toczydlowski 

#--------------- EXECUTABLE ---------------

# load modules
module purge
module load FastQC/0.11.7-Java-1.8.0_162
module list

# run fastQC
# required variables imported from wrapper script: 
#	(1) $ARRAY_KEY, a text file with the path and filename of a sequence to run through fastQC on a single line
#	(2) $OUTDIR, the path to the output directory 

# define SEQFILE using ARRAY_KEY
SEQFILE=$(awk -v row=1 'NR=row{print ${SLURM_ARRAY_TASK_ID}' $ARRAY_KEY | tr -d '/r')

echo SEQFILE defined as $SEQFILE

# run fastQC
fastqc $SEQFILE --outdir=$OUTDIR

wait

echo fastQC run on $SEQFILE and output stored in $OUTDIR

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------









	










