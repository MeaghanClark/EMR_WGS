#!/bin/bash

#--------------- EXECUTABLE ---------------

# This script calls snps
# Last updated 03/01/2023 by MI Clark, based on script by R Toczydlowski. Shout out to T Linderoth for helping establish reasonable SNP calling parameters
# Input: Reference genome path, bam file, input directory, output directory from wrapper-call_snps.sh 
#
# Output: ${OUTDIR}/${SAMPLE_NAME}.bcf  file, stored in directory at <storagenode>/<run_name>/called_snps
#			example: /mnt/home/clarkm89/massasauga/called_snps/PCC_321.bcf 

echo we are starting calling snps!

#load programs we want to use
module purge
module load powertools
module load GCC/10.2.0
module load GSL/2.6
module list 
 
bcftools --version

# text for troubleshooting
echo using $REFERENCE 
echo I will put the output in ${OUTDIR}/${VCF_NAME}.bcf 

# Required import variables from wrapper
#	(1) reference
#	(2) list of bamfiles
#	(3) OUTDIR

# path to a file that contains the list of chromosomes for this array job no. 
CHROMLIST="${CHROM_LIST_DIR}/chrom_list_${SLURM_ARRAY_TASK_ID}.txt" # path to list of chromosomes
BCF_NAME=EMR_WGS_${SLURM_ARRAY_TASK_ID}


# parameter recs from T Linderoth
 bcftools mpileup \
 -f $REFERENCE \
 -b $LIST_OF_BAMFILES \
 -R $CHROMLIST \ # list of chromosomes to call SNPs on
 -C 0 \
 -d 10000 \
 -L 10000 \
 -q 20 \
 -Q 13 \
 --ns "UNMAP,SECONDARY,QCFAIL,DUP" \
 -a "FORMAT/AD,FORMAT/DP,FORMAT/QS,FORMAT/SP,FORMAT/SCR,INFO/AD,INFO/SCR" \
 -p \
 -O u \
 | bcftools call \
 -a PV4,GQ,GP \
 -m \
 -P 0.003 \
 -O u \
 | bcftools +fill-tags \
 -O b \
 -o ${OUTDIR}/${BCF_NAME}.bcf.gz \
-- -t 'AF,ExcHet,NS'
 
echo I have called SNPs using $LIST_OF_BAMFILES and $REFERENCE
echo I have also output a bcf file and saved it here: ${OUTDIR}/${BCF_NAME}.bcf

wait

tabix -p bcf $OUTBCF

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------

