#!/bin/bash --login

# calc_pairwiseFst.sbatch
# M. Clark 09/23/2024, updated 09/23/2024

# use vcftools to calculate Fst

# define variables 
VCF='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/variants_highQual/EMR_highQual_SNPs_nomaf_chrom_drop.vcf.gz'

# FST
populations=($(ls ${POPDIR}/*.txt)) # get list of population files 


# loop thorugh populations and make pairs 

# Run vcftools Fst calculation
vcftools --gzvcf $VCF \
         --weir-fst-pop $FILE1 \
         --weir-fst-pop $FILE2 \
         --out ${OUTDIR}/${PREFIX}_fst_${SITE1}_${SITE2}

echo "Calculated Fst for ${site1} vs ${site2}"

wait 

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
