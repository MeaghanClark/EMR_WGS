#!/bin/bash

# run_multiQC.sbatch
# This script runs multiQC on fastQC reports to produce a summary report
# Last updated 05/16/2024 by MI Clark, script format inspired by R Toczydlowski 

#--------------- EXECUTABLE ---------------

# load modules
module purge
module load GCC/7.3.0-2.30  OpenMPI/3.1.1
module load MultiQC/1.7-Python-3.6.6
module list

# required variables: 
INDIR=path/to/fastQC/files
OUTDIR=path/to/output/dir

# run multiQC

multiqc $INDIR --outdir $OUTDIR

wait


echo multiQC run on fastQC reports in $INDIR and output stored in $OUTDIR

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
