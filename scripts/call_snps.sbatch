#!/bin/bash

#--------------- EXECUTABLE ---------------

# This script calls snps
# Last updated 06/22/2024 by MI Clark, based on script by R Toczydlowski. Shout out to T Linderoth for helping establish reasonable SNP calling parameters
# Input: Reference genome path, bam file, input directory, output directory from wrapper-call_snps.sh 
#
# Output: ${OUTDIR}/${SAMPLE_NAME}.bcf  file, stored in directory at <storagenode>/<run_name>/called_snps
#			example: /mnt/home/clarkm89/massasauga/called_snps/PCC_321.bcf 

echo we are starting calling snps!

#load programs we want to use, updated to ubuntu
module purge
module load powertools
module load BCFtools/1.19-GCC-13.2.0
module list 
 
bcftools --version


# Required import variables from wrapper
#	(1) reference
#	(2) list of bamfiles
#	(3) OUTDIR

# path to a file that contains the list of chromosomes for this array job no. 
CHROMLIST="${CHROM_LIST_DIR}/chrom_list_${SLURM_ARRAY_TASK_ID}.txt" # path to list of chromosomes
BCF_NAME=EMR_WGS_${SLURM_ARRAY_TASK_ID}


# text for troubleshooting
echo using $REFERENCE 
echo I will put the output in ${OUTDIR}/${BCF_NAME}.bcf 

# make sure .bam files are indexed! 
# while read -r bam_file; do
#     samtools index "$bam_file"
# done < /mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/bam_list.txt

# parameter recs from T Linderoth
 bcftools mpileup \
 -f $REFERENCE \
 -b $LIST_OF_BAMFILES \
 -R $CHROMLIST \
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

