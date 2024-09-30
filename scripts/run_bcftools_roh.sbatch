#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=48:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --array=0-3
#SBATCH --cpus-per-task=12         # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=50G            # memory required per allocated CPU (or core)
#SBATCH --job-name=bcf_roh     # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/logs/roh/bcf_roh_%A.out"
#SBATCH --error="/mnt/research/Fitz_Lab/logs/roh/bcf_roh_%A.err"
#SBATCH --account=bradburd
##########
# run_bcftools_roh.sbatch
# M. Clark, 09/30/2024

#load programs we want to use
module purge
module load powertools
module load BCFtools/1.19-GCC-13.2.0
module list

bcftools --version

# define sample set 
FILES=("BBI_inds.txt" "NMI_inds.txt" "SMI_inds.txt" "OH_inds.txt")

SAMP=/mnt/research/Fitz_Lab/scripts/keys/roh_groups/${FILES[${SLURM_ARRAY_TASK_ID}]}.txt

echo using $SAMP

VCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/variants_highQual/EMR_highQual_SNPs_nomaf_chrom_drop.vcf.gz
OUTPUT=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/roh/EMR_highQual_SNPs_nomaf_chrom_drop_roh.txt
CPUS=12

bcftools roh --samples $SAMP -rec-rate 1.79e-8 -e GT,- --threads $CPUS --output $OUTPUT $VCF 


#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------