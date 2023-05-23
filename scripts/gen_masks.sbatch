#!/bin/bash

#--------------- EXECUTABLE ---------------

# This script generates bed file of site masks based on bam statistics
# Last updated 05/18/2023 by MI Clark,based on script by T Linderoth

#load programs we want to use
module purge
module load powertools
module load GCC/10.2.0
module load GSL/2.6
module list 

### create bed file of masks

echo The date is $DATE

CMD="$EXEC --mindepth 118 --maxdepth 354 --minmq 35 --maxmq0 0.1 --minbq 20 --maxbq0 0.1 $BAMSTATS $OUTPREFIX > $REPORT"
# changed parameters based on output from make_bamstats_hists
# min and max depth are +/0 0.5 around the median depth of 236
printf "\n%s\n\n" "$CMD"
eval $CMD


#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
seff ${SLURM_JOBID}
