#!/bin/bash

# trim_reads.sbatch
# This script runs fastp on raw sequencing data to trim adapters and polyG tails
# Last updated 06/16/2024 by MI Clark, script format inspired by R Toczydlowski 

#--------------- EXECUTABLE ---------------

fastp --version # will work on ubuntu! 


# define read files using ARRAY_KEY
line=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$ARRAY_KEY")
IFS=$'\t' read -r FORWARDREAD REVERSEREAD <<< "$line"


BASE=$(basename "$FORWARDREAD")
IND_NAME=$(echo "${BASE}" | cut -d "_" -f 1) # 1,2 if there is a "_" in ind id 


# required variables: 

#CUTADAPT=/mnt/research/Fitz_Lab/software/cutadapt/bin/cutadapt
FORWARD_ADAPTER=AGATCGGAAGAGCACACGTCTGAACTCCAGTCA # truseq adapters, should double check these are correct
REVERSE_ADAPTER=AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT
REPORT=${IND_NAME}.fastp.html


# # trim adapters
# $CUTADAPT \
#         -a $FORWARD_ADAPTER \ 
#         -A $REVERSE_ADAPTER \
#         --report=full    \
#         -o trim.${OUTDIR}/${FORWARDREAD} -p trim.${OUTDIR}/${REVERSEREAD} \
#         ${INDIR}/$FORWARDREAD ${INDIR}/$REVERSEREAD

# wait

# trim polyG tails
fastp -i ${FORWARDREAD} \
	-I ${REVERSEREAD} \
	-o ${OUTDIR}/trim.${IND_NAME}_1.fastq.gz \
	-O ${OUTDIR}/trim.${IND_NAME}_2.fastq.gz \
	--adapter_sequence $FORWARD_ADAPTER \
	--adapter_sequence_r2 $REVERSE_ADAPTER \
	-g \
	--poly_g_min_len 10 \
	--html=${OUTDIR}/${REPORT}

wait

echo fastp run on $FORWARDREAD and $REVERSEREAD to discard adapter contamination and PolyG tails. 

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
