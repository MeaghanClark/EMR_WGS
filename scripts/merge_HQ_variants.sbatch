#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=12:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=24G            # memory required per allocated CPU (or core)
#SBATCH --job-name=merge_HQ_var    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/flt_HQ_var/merge_HQ_var_%A.out" 
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/flt_HQ_var/merge_HQ_var_%A.err"
#SBATCH --account=bradburd
##########

# merge_HQ_variants.sbatch
# M. Clark 09/23/2024, updated 09/23/2024

# merge vcf high quality variants files and filter to retain desired autosomal chromosomes

# define variables 

VCF_LIST=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/vcf_highQual_var_list.txt # list of vcf file form flt_high_qual_snps.sbatch, in order of chromosome chunk
KEEP_CHROM=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/ref_chromosome_list.txt   # list of chromosomes to retain in output VCF file
OUTVCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/variants_highQual/EMR_highQual_variants_nomaf_chrom.vcf.gz

# concat high quality variants vcf files, then filter to only retain sites on autosomal chromosomes 
bcftools concat -n -Ou --file-list $VCF_LIST | bcftools view -R $KEEP_CHROM -Oz -o $OUTVCF

tabix -p vcf $OUTVCF

wait 


#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------