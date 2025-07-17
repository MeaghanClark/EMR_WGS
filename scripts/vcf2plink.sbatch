#!/bin/bash

########## SBATCH Lines for Resource Request ##########

#SBATCH --time=12:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1         # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=50G            # memory required per allocated CPU (or core)
#SBATCH --job-name=plink      # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/plink/vcf_2_plink_%A.out"
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/plink/vcf_2_plink_%A.err"
#SBATCH --account=bradburd
##########
# vcf2plink.sbatch
# M. Clark, updated 09/25/2024
# This script converts a vcf file to plink format

#--------------- EXECUTABLE --------------

module purge
module load PLINK/1.9b_6.21-x86_64
module load powertools
module list

# define variables
INDIR=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/variants_highQual
VCF_NAME=EMR_highQual_SNPs_nomaf_chrom_drop.vcf.gz
OUTDIR=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/variants_highQual/plink

# make plink files from vcf
plink --vcf ${INDIR}/${VCF_NAME} --biallelic-only 'strict' --vcf-half-call 'missing' --double-id --recode --allow-extra-chr --out ${OUTDIR}/${VCF_NAME}


#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------

