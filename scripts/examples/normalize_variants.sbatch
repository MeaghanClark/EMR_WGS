#!/bin/bash

#--------------- EXECUTABLE ---------------

# This script runs bcftools norm on a zipped bcf file
# Last updated 04/11/2023 by MI Clark,based on script by T Linderoth
# Input: Reference genome with path, zipped bcf file
#
# Output: normalized zipped bcf file 

#load programs we want to use
module purge
module load powertools
module load GCC/10.2.0
module load GSL/2.6
module list 

bcftools --version

# Required import variables from wrapper
#	(1) reference
#	(2) list of bcf files
#	(3) OUTDIR

# path to a file that contains the list of chromosomes for this array job no. 
CHROMLIST="${CHROM_LIST_DIR}/chrom_list_${SLURM_ARRAY_TASK_ID}.txt" # path to list of chromosomes
INBCF_NAME=EMR_WGS_${SLURM_ARRAY_TASK_ID}
OUTBCF_NAME=EMR_WGS_norm_${SLURM_ARRAY_TASK_ID}

### Normalize variants

echo I am running bcftools norm using $REFERENCE, $OUTBCF, and $INBCF as imported from the wrapper script
echo
echo The date is $DATE

#echo done indexing using tabix

CMD="bcftools norm -f $REFERENCE -O b -o ${OUTDIR}/${OUTBCF_NAME} --threads $CPUS ${INDIR}/${INBCF_NAME}"

printf "\n%s\n\n" "$CMD"

eval $CMD

wait

tabix -p bcf $OUTBCF


#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
seff ${SLURM_JOBID}
