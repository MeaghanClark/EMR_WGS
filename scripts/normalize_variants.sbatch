#!/bin/bash

#--------------- EXECUTABLE ---------------

# This script runs bcftools norm on a zipped bcf file
# Last updated 09/03/2023 by MI Clark,based on script by T Linderoth
# Input: Reference genome with path, zipped bcf file
#
# Output: normalized zipped bcf file 

# troubleshooting line for "mystery node issues"
source /etc/profile
module -b list

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
INBCF_NAME=EMR_WGS_raw.bcf.gz
OUTBCF_NAME=EMR_WGS_byScaf_norm_${SLURM_ARRAY_TASK_ID}.bcf.gz
SCAF_FILE=${CHROM_LIST_DIR}/Scaf_${SLURM_ARRAY_TASK_ID}.txt


### Normalize variants

echo I am running bcftools norm using $REFERENCE, $SCAF_FILE, ${OUTDIR}/${OUTBCF_NAME}, and ${INDIR}/${INBCF_NAME} as imported from the wrapper script and defined here
echo
echo The date is $DATE

CMD="bcftools norm -f $REFERENCE -R $SCAF_FILE --threads ${CPUS} -O b -o ${OUTDIR}/${OUTBCF_NAME} ${INDIR}/${INBCF_NAME}"

printf "\n%s\n\n" "$CMD"

eval $CMD

wait

tabix -p bcf ${OUTDIR}/${OUTBCF_NAME}

printf "--FIN--"


#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
