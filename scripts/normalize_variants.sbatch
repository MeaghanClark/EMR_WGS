#!/bin/bash

#--------------- EXECUTABLE ---------------

# This script runs bcftools norm on a zipped bcf file
# Last updated 07/01/2023 by MI Clark,based on script by T Linderoth
# Input: Reference genome with path, zipped bcf file
#
# Output: normalized zipped bcf file 

#load programs we want to use
module purge
module load powertools
module load BCFtools/1.19-GCC-13.2.0
module list 

bcftools --version

# Required import variables from wrapper
#	(1) reference
#	(3) OUTDIR

# path to a file that contains the list of chromosomes for this array job no. 
INBCF_NAME=EMR_WGS_drop.bcf.gz
OUTBCF_NAME=EMR_WGS_drop_norm.bcf.gz
### Normalize variants

echo I am running bcftools norm using $REFERENCE, $OUTBCF, and $INBCF as imported from the wrapper script
echo
echo The date is $DATE

#echo done indexing using tabix

CMD="bcftools norm -f $REFERENCE --threads ${CPUS} -O b -o ${OUTDIR}/${OUTBCF_NAME} --threads $CPUS ${INDIR}/${INBCF_NAME}"

printf "\n%s\n\n" "$CMD"

eval $CMD

wait

tabix -p bcf ${OUTDIR}/${OUTBCF_NAME}


#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
