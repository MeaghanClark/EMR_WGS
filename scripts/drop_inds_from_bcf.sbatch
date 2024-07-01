#!/bin/bash

# This script drops individuals using the bcftools -s tag 
# Last updated 07/01/2024 by MI Clark

#load programs we want to use, updated for ubuntu

module purge
module load powertools
module load BCFtools/1.19-GCC-13.2.0
module list 

bcftools --version

echo ${BCFLIST}

BCF_FILE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$BCFLIST")


# isolate bcf name
BCF_NAME=$(echo "${BCF_FILE}" | cut -d "." -f 1)

# drop individuals and resave 
bcftools view -s ^/mnt/scratch/clarkm89/EMR_WGS/alignments/KBPP_sca0242.trim.bam,/mnt/scratch/clarkm89/EMR_WGS/alignments/KBPP_sca0144.trim.bam,/mnt/scratch/clarkm89/EMR_WGS/alignments/KBPP_sca0180.trim.bam,/mnt/scratch/clarkm89/EMR_WGS/alignments/ROME_sca0713.trim.bam,/mnt/scratch/clarkm89/EMR_WGS/alignments/ROME_sca1395.trim.bam,/mnt/scratch/clarkm89/EMR_WGS/alignments/SSSP_sca0979.trim.bam \
-o ${OUTDIR}/${BCF_NAME}_drop.bcf.gz \
-O b \
${INDIR}/${BCF_FILE}

echo done dropping individuals...

# index bcf files 
tabix -p bcf ${OUTDIR}/${BCF_NAME}_drop.bcf.gz

wait 

echo done indexing... 

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------

