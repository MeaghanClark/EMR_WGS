#!/bin/bash

########## SBATCH Lines for Resource Request ##########

#SBATCH --time=168:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=100G            # memory required per allocated CPU (or core)
#SBATCH --job-name=merge_norm_rename_index    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/merge_norm_rename_index/merge_bcf_%A.out"
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/merge_norm_rename_index/merge_bcf_%A.err"
#SBATCH --account=bradburd

##########

# This script merges bcf files into a single file, normalizes them, and indexes the output
# Last updated 07/03/2024 by MI Clark, based on script by T Linderoth

#load programs we want to use, updated for ubuntu
module purge
module load powertools
module load BCFtools/1.19-GCC-13.2.0
module list 

bcftools --version

# define variables
BCF_LIST='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/bcf_chrom_list.txt' # list with full file paths to bcf files to merge, make sure the files are in the correct order! 
OUTFILE='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/EMR_WGS_drop_norm_rename2.bcf.gz' 

# merge bcf files in correct order 
bcftools concat \
-n \
--file-list ${BCF_LIST} \
-O u \
| bcftools norm \
-f $REFERENCE \
-O b \
-o $OUTFILE

# index bcf
tabix -p bcf $OUTFILE


# output 


#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------





