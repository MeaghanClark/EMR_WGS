#!/bin/bash

#--------------- EXECUTABLE ---------------

# This script calls snps
# Last updated 08/30/2024 by MI Clark

echo we are indexing bams!

#load programs we want to use, updated to ubuntu
module purge
module load SAMtools/1.18-GCC-12.3.0
module load powertools
module list 

while read -r bam_file; do
    samtools index "$bam_file" 
done < $LIST_OF_BAMFILES


#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------

