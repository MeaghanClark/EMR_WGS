#!/bin/bash

#--------------- EXECUTABLE ---------------

# This script generates bed file of site masks based on bam statistics
# Last updated 04/11/2023 by MI Clark,based on script by T Linderoth

#load programs we want to use
module purge
module load powertools
module load GCC/10.2.0
module load GSL/2.6
module list 

### create bed file of masks

echo The date is $DATE

CMD="$EXEC --mindepth 110 --maxdepth 1514 --minmq 35 --maxmq0 0.1 --minbq 20 --maxbq0 0.01 $BAMSTATS $OUTPREFIX > $REPORT"
# changed mindepth from 220 to 110 because I have fewer individuals than tha posk project, should double check that this was okay with Tyler
printf "\n%s\n\n" "$CMD"
eval $CMD


#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
seff ${SLURM_JOBID}
