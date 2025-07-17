#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=12:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --array=1-200
#SBATCH --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=24G            # memory required per allocated CPU (or core)
#SBATCH --job-name=flt_hcov_inds    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/flt_hcov_inds/flt_hcov_inds_%A-%a.out" 
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/flt_hcov_inds/flt_hcov_inds_%A-%a.err"
#SBATCH --account=bradburd
##########

# flt_inds.sbatch
# M. Clark 09/22/2024, updated 12/30/2024

# filter to retain high coverage individuals for EMR WGS project
# retain individuals with 12X average genome-wide depth or greater

module purge
module load powertools
module load BCFtools/1.19-GCC-13.2.0
module list

bcftools --version 

# define variables 
# VCF
# for variants:
VCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/variants_noMAF/all_inds/EMR_variants_nomaf_${SLURM_ARRAY_TASK_ID}.vcf.gz # all sites, all inds VCF
# for all sites:
#VCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/annotated_vcf/EMR_annotated_${SLURM_ARRAY_TASK_ID}.vcf.gz # all sites, all inds VCF

# SAMPLES
# for all: 
SAMPLES=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/high_qual_inds.txt

# OUTPUT VCF
#for variants:
OUTVCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/variants_noMAF/high_cov_inds/EMR_variants_nomaf_highcov_${SLURM_ARRAY_TASK_ID}.vcf.gz
# for all sites
#OUTVCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/allsites/high_qual_inds/EMR_allsites_highqual_${SLURM_ARRAY_TASK_ID}.vcf.gz

# SAMPLES file is a list of individuals to retain in the output VCF, one name per line

# run commands 
bcftools view -S $SAMPLES -Oz -o $OUTVCF $VCF

tabix -p vcf $OUTVCF

wait 

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
