#!/bin/bash

#--------------- EXECUTABLE ---------------

# This script merges bam files 
# Last updated 04/15/2023 by MI Clark,based on script by T Linderoth
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

REFERENCE='/mnt/research/Fitz_Lab/ref/butterfly/posk/POSK_Genome.fasta'
BAMS='/mnt/research/Fitz_Lab/projects/posk/map/mi_posk_bam_list_qc.txt'
OUTFILE='/mnt/gs21/scratch/lindero1/posk/mask/mi_posk_all_qc.bam'

CMD="samtools merge -O BAM --reference $REFERENCE -b $BAMS -o $OUTFILE -@ $CPUS"

printf "\n%s\n\n" "$CMD"

eval $CMD

wait

samtools index -@ $CPUS "$OUTFILE"


#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
seff ${SLURM_JOBID}
