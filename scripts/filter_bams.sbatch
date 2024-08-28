#!/bin/bash

# filter_bams.sbatch
# This script uses samtools to filter and process raw .bam alignment files
# resulting bam files are  indexed, sorted, duplicates are flagged, and read pair overlap is trimmed
# Last updated 08/27/2024 by MI Clark, originally written by MI Clark and R Toczydlowski based on scripts by B Reid and T Linderoth

#--------------- EXECUTABLE ---------------

# This script aligns pairs of forward and reverse sequence files listed in a text file to the given reference and trims overlap between read pairs
# Input: Reference genome path, forward and reverse reads from wrapper-align_to_genome.sh 
#
# Output: ${SAMPLE_NAME}.trim.bam file, forward and reverse reads aligned to reference genome and trimmed

# load modules, updated to ubuntu
module purge
module load SAMtools/1.18-GCC-12.3.0
module load powertools
module list 
 
# required imports from wrapper: 
#	ARRAY_KEY
# 	CPUS
#	OUTDIR
#	SCRATCHNODE

line=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$ARRAY_KEY")

IFS=$'\t' read -r FORWARDREAD REVERSEREAD <<< "$line"
BASE=$(basename "$FORWARDREAD")
SAMPLE_NAME=$(echo "${BASE}" | cut -d "_" -f 1,2 | cut -d "." -f 2)

# text for troubleshooting
echo I will put the output in ${SCRATCHNODE}/${SAMPLE_NAME}.trim.bam 

samtools sort -n ${INDIR}/${SAMPLE_NAME}.aln-pe.bam | \
samtools fixmate -m - - | \
samtools sort - | \
samtools markdup -@ $CPUS -r - ${SCRATCHNODE}/${SAMPLE_NAME}.rmdup.bam 

# removing step to filter out unpaired reads: # samtools view -h -f 0x2 - | \

echo I am all done with using samtools to filter ${SAMPLE_NAME}.aln-pe.bam 

wait 

# trim overlap
bam clipOverlap --in ${SCRATCHNODE}/${SAMPLE_NAME}.rmdup.bam --stats --out ${OUTDIR}/${SAMPLE_NAME}.trim.bam 

wait

# done

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
