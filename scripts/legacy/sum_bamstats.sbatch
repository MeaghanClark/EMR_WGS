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
module load GCC/8.3.0 OpenMPI/3.1.4
module load R/4.0.2
module list 

bcftools --version

### Normalize variants

echo The date is $DATE

CMD="$RSCRIPT $STATLIST $OUTFILE 3 4 5 6 7 8 9"
printf "\n%s\n\n" "$CMD"
eval $CMD


#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
seff ${SLURM_JOBID}
