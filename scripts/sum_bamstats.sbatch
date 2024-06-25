#!/bin/bash

########## SBATCH Lines for Resource Request ##########

#SBATCH --time=48:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=120G            # memory required per allocated CPU (or core)
#SBATCH --job-name=sum_bamstats    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/sum_bamstats/sum_bamstats_%A.out" # CHANGE
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/sum_bamstats/sum_bamstats_%A.err" # CHANGE

##########

# This script reads bamstats files into R, calculates a summary, and outputs a .pdf report containing histograms of stats
# Last updated 06/24/2024 by MI Clark, based on script by T Linderoth

#load programs we want to use, updated for ubuntu
module purge
module load powertools
module load R/4.3.2-gfbf-2023a
module list 

# define variables
RSCRIPT='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/qualSummaryStats.R' 
STATLIST='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/EMR_bamstats_list.txt' # list containing (probably) 1 merged bamstats filename
OUTFILE_SUM='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/bamstats/EMR.bamstats.summary' # summary output 
OUTFILE_HIST='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/bamstats/EMR.bamstats.summary.pdf'

# run command 

CMD="$RSCRIPT $STATLIST $OUTFILE_SUM $OUTFILE_HIST 3 4 5 6 7 8 9"
printf "\n%s\n\n" "$CMD"
eval $CMD

wait

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
