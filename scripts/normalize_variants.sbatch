#!/bin/bash

#--------------- EXECUTABLE ---------------

# This script runs bcftools norm on a zipped bcf file
# Last updated 04/11/2023 by MI Clark,based on script by T Linderoth
# Input: Reference genome with path, zipped bcf file
#
# Output: normalized zipped bcf file 

#load programs we want to use
#load programs we want to use
module purge
module load powertools
module load GCC/10.2.0
module load GSL/2.6
module list 

bcftools --version

### Normalize variants

echo I am running bcftools norm using $REFERENCE, $OUTBCF, and $INBCF as imported from the wrapper script
echo
echo The date is $DATE

#echo indexing $INBCF... 
#tabix -p bcf $INBCF

#echo done indexing using tabix

CMD="bcftools norm -f $REFERENCE -O b -o $OUTBCF --threads $CPUS $INBCF"

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
