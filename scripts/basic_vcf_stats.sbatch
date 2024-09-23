#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=12:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=24G            # memory required per allocated CPU (or core)
#SBATCH --job-name=basic_stats    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/basic_stats/basic_stats_%A.out" 
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/basic_stats/basic_stats_%A.err"
#SBATCH --account=bradburd
##########

# basic_vcf_stats.sbatch
# M. Clark 09/23/2024, updated 09/23/2024

# use vcftools to calculate some basic statistics from vcfs

# define variables 
VCF='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/variants_highQual/EMR_highQual_variants_nomaf_chrom.vcf.gz'
OUTDIR='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/stats_highQual/'

# allele frequencies --freq 
vcftools --gzvcf $VCF --freq --out ${OUTDIR}/EMR_highQualVar_nomaf_chrom_allele_freqs
echo calculated allele frequencies

# individual depth --depth
vcftools --gzvcf $VCF --depth --out ${OUTDIR}/EMR_highQualVar_nomaf_chrom_ind_depth
echo calculated ind depth

# individual heterozygosity --het 
vcftools --gzvcf $VCF --het --out ${OUTDIR}/EMR_highQualVar_nomaf_chrom_ind_het
echo calculated ind het

# site depth --site-mean-depth
vcftools --gzvcf $VCF --site-mean-depth --out ${OUTDIR}/EMR_highQualVar_nomaf_chrom_site_depth
echo calculated site depth

# singletons --singletons
vcftools --gzvcf $VCF --singletons --out ${OUTDIR}/EMR_highQualVar_nomaf_chrom_singletons
echo calculated singletons

wait 

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------