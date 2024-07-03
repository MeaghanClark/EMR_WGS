#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########

#SBATCH --time=48:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1         # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=50G            # memory required per allocated CPU (or core)
#SBATCH --job-name=index      # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/index/index_%A.out"
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/index/index_%A.err"
#SBATCH --account=bradburd

##########

# index bcf file

BCF_FILE=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/EMR_WGS_drop_norm_rename.bcf.gz

# index file
tabix -p bcf $BCF_FILE

wait 

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------


