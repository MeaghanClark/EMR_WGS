#!/bin/bash

# trim_reads.sbatch
# This script runs fastp on raw sequencing data to trim adapters and polyG tails
# Last updated 05/16/2024 by MI Clark, script format inspired by R Toczydlowski 

#--------------- EXECUTABLE ---------------

fastp --version


# define read files using ARRAY_KEY
read -r FORWARDREAD REVERSEREAD <<< $(awk -v row=${SLURM_ARRAY_TASK_ID} -F'	' 'NR=row{print $1 $2}' $ARRAY_KEY | tr -d '/r') # is -F tag correct? 

FORWARDREAD=$((FORWARDREAD))
REVERSEREAD=$((REVERSEREAD))

IND_NAME=$(echo $FORWARDREAD | cut -d "_" -f 1,2) # ***CHANGE THIS LINE DEPENDING ON NAMING CONVENTION***


# required variables: 

CUTADAPT=/mnt/research/Fitz_Lab/software/cutadapt/bin/cutadapt
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
fastp \ 
	-i ${INDIR}/${FORWARDREAD}
	-I ${INDIR}/${REVERSEREAD}
	-o trim.${OUTDIR}/${FORWARDREAD}
	-O trim.${OUTDIR}/${REVERSEREAD}
	--adapter_sequence $FORWARD_ADAPTER
	--adapter_sequence_r2 $REVERSE_ADAPTER
	-g 
	--poly_g_min_len 10
	-h=${REPORT}

wait

echo fastp run on $FORWARDREAD and $REVERSEREAD to discard adapter contamination and PolyG tails. 

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
