#!/bin/bash

# query_SRA.sbatch
# This script downloads sequences from the SRA database
# Last updated 06/13/2024 by MI Clark
# based on https://hbctraining.github.io/Accessing_public_genomic_data/lessons/downloading_from_SRA_odyssey.html
# and https://edwards.flinders.edu.au/fastq-dump/

#--------------- EXECUTABLE ---------------

# load modules
module purge
module load GCC/11.3.0  OpenMPI/4.1.4
module load SRA-Toolkit/3.0.3
module list

# define SEQ_ID using ARRAY_KEY

SEQ_ID=$(awk -v row="${SLURM_ARRAY_TASK_ID}" 'NR==row{print $0}' $ARRAY_KEY | tr -d '\r')

echo SEQFILE defined as $SEQFILE

# query SRA using fastq-dump
fastq-dump --outidr ${OUTDIR} --skip-technical --readids --read-filter pass --dumpbase --split-3 --clip -e ${CPUS} ${SEQ_ID}

wait

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------