#!/bin/bash

#--------------- EXECUTABLE ---------------

# this script calls snps
		# Last updated 08/24/2020 by MI Clark, based on script by R Toczydlowski
# input: Reference genome path, bam file, input directory, output directory from wrapper-call_snps.sh 
#
# output: ${OUTDIR}/${SAMPLE_NAME}.bcf  file, stored in directory at <storagenode>/<run_name>/called_snps
#			example: /mnt/home/clarkm89/massasauga/called_snps/PCC_321.bcf 

# importing: REFERENCE, CPUS, RUN_NAME, VCF_NAME, LIST_OF_BAMFILES, STORAGENODE=, SCRATCHNODE, INDIR, OUTDIR, LOGFILESDIR

# Testing
echo we started calling snps!

#load programs we want to use
module purge
module load GCC/6.4.0-2.28
module load OpenMPI/2.1.2
module load bcftools/1.9.64
module load powertools
module list 
 
# text for troubleshooting
echo using $REFERENCE 
echo I will put the output in ${OUTDIR}/${VCF_NAME}.bcf 

echo THIS IS A REAL RUN

# run bcftools
# removed filtering options: -C 50 -d 250 -q 20 -Q 30
bcftools mpileup -a "AD,ADF,ADR,DP,SP,INFO/AD,INFO/ADF,INFO/ADR" --threads $CPUS -g 5 -f $REFERENCE -C 50 -d 250 -q 20 -Q 30 -b $LIST_OF_BAMFILES | \
bcftools call -m -Ob -p 0.01 -P 0.001 -g 5 -o ${OUTDIR}/${VCF_NAME}.bcf
bcftools view ${OUTDIR}/${VCF_NAME}.bcf > ${OUTDIR}/${VCF_NAME}_gvcf.vcf

echo I have called SNPs using $LIST_OF_BAMFILES and $REFERENCE
echo I have also output a bcf file and saved it here: ${OUTDIR}/${VCF_NAME}.bcf
echo Finally, I have converted the bcf file to a vcf file and saved it here: ${OUTDIR}/${VCF_NAME}_gvcf.vcf

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------

