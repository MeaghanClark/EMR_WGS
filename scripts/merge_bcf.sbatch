#!/bin/bash

########## SBATCH Lines for Resource Request ##########

#SBATCH --time=24:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=24G            # memory required per allocated CPU (or core)
#SBATCH --job-name=merge_bcf    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/merge_bcf/merge_bcf_%A.out"
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/merge_bcf/merge_bcf_%A.err"
#SBATCH --account=bradburd

##########

# This script merges bcf files into a single file
# Last updated 06/24/2024 by MI Clark, based on script by T Linderoth

#load programs we want to use, updated for ubuntu
module purge
module load powertools
module load BCFtools/1.19-GCC-13.2.0
module list 

bcftools --version

# define variables
BCF_LIST='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/bcf_chrom_list.txt' # list with full file paths to bcf files to merge
OUTFILE='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/EMR_WGS_drop.bcf.gz' 

# -a allows for duplicated sites (which might have happened due to upstream errors?) and -d removes duplicated lines in the bcf files being merged
CMD="bcftools concat -n -o $OUTFILE -Ob --file-list ${BCF_LIST}"

# run command 

printf "\n%s\n\n" "$CMD"

eval $CMD

wait

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------


