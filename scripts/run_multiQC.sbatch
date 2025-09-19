#!/bin/bash

# run_multiQC.sbatch
# This script runs multiQC on fastQC reports to produce a summary report
# Last updated 06/16/2024 by MI Clark, script format inspired by R Toczydlowski 

#--------------- EXECUTABLE ---------------

# load modules
module purge
module load MultiQC/1.14-foss-2022b
module list

# required variables: 
# for FASTQC: 
#INDIR=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/rawReadsQC
#OUTDIR=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/rawReadsQC
# for fastp
INDIR=/mnt/scratch/clarkm89/EMR_WGS/processedReads/
OUTDIR=/mnt/scratch/clarkm89/EMR_WGS/processedReads/

# run multiQC

multiqc $INDIR --outdir $OUTDIR

wait


echo multiQC run on fastQC reports in $INDIR and output stored in $OUTDIR

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
