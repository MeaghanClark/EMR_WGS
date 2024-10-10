#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=12:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --array=1-222
#SBATCH --cpus-per-task=5       # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=50G            # memory required per allocated CPU (or core)
#SBATCH --job-name=pixy_div     # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/pixy_div/pixy_div_%A-%a.out"
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/pixy_div/pixy_div_%A-%a.err"
#SBATCH --account=bradburd
##########

# pixy_diversity.sbatch
# M. Clark, 10/10/2024

# load conda dir with pixy installation
source activate pixy

# define variables
VCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/allsites/highQualInds_Sites/EMR_allsitesHQ_highQual_chrom.vcf.gz
POP_FILE=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/highQual_pixy_populations.txt

pixy --stats pi dxy \
--vcf $VCF \
--populations $POP_FILE \
--window_size 10000 \
--n_cores 5 \


#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
