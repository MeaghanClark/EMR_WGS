#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=12:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --array=1-200
#SBATCH --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=24G            # memory required per allocated CPU (or core)
#SBATCH --job-name=flt_HQ_var    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/flt_HQ_var/flt_HQ_var_%A-%a.out" 
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/flt_HQ_var/flt_HQ_var_%A-%a.err"
#SBATCH --account=bradburd
##########

# flt_high_qual_snps_.sbatch
# M. Clark 09/23/2024, updated 09/23/2024

# use .pos file from high_qual_snps.sbatch to output vcf files for high quality SNPS in high coverage individuals

module purge
module load powertools
module load BCFtools/1.19-GCC-13.2.0
module list

bcftools --version 

# define variables 
VCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/variants_noMAF/high_cov_inds/EMR_variants_nomaf_highcov_${SLURM_ARRAY_TASK_ID}.vcf.gz # all variants VCF, high coverage individuals
INCLUDE=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/highQual_SNPs/90_percent_cutoff/EMR_highQual_varfilter_${SLURM_ARRAY_TASK_ID}.pos # sites that pass genotype call quality filtering from extract_highQuality_sites.sbatch
OUTVCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/variants_highQual/EMR_highQual_variants_nomaf_${SLURM_ARRAY_TASK_ID}.vcf.gz 

# filter VCF and output and new VCF
bcftools view -T $INCLUDE -Oz -o $OUTVCF $VCF 

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
