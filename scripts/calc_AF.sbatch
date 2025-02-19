#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=12:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --array=0-3
#SBATCH --cpus-per-task=1         # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=50G            # memory required per allocated CPU (or core)
#SBATCH --job-name=AF     # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/roh/AF_%A-%a.out"
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/roh/AF_%A-%a.err"
#SBATCH --account=bradburd
##########
# calc_AF.sbatch 
# M. Clark, 09/30/2024

#load programs we want to use
module purge
module load powertools
module load BCFtools/1.19-GCC-13.2.0
module list

bcftools --version

# define sample set 
FILES=("BBI_inds" "NMI_inds" "SMI_inds" "OH_inds")

VCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/variants_highQual/EMR_highQual_SNPs_nomaf_chrom_drop.vcf.gz
SAMP=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/roh_groups/${FILES[${SLURM_ARRAY_TASK_ID}]}.txt
echo using $SAMP
SAMPLES=$(cat $SAMP)
OUTFILE=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/roh/allele_freqs/EMR_highQual_SNPs_nomaf_chrom_drop_${FILES[${SLURM_ARRAY_TASK_ID}]}_altAF.tab.gz


# calculate allele frequencies
bcftools view -s $SAMPLES $VCF | bcftools +fill-tags -Ou -- -t all | bcftools query -f'%CHROM\t%POS\t%REF,%ALT\t%INFO/AF\n'| bgzip -c > $OUTFILE

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
