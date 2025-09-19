#!/bin/bash

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=96:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1         # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=500G            # memory required per allocated CPU (or core)
#SBATCH --job-name=bamstats_sum     # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/bamstats_sum/bamstats_sum_%A.out"
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/bamstats_sum/bamstats_sum_%A.err"
#SBATCH --account=bradburd
##########

# This script runs bcftools norm on a zipped bcf file
# Last updated 09/11/2024 by MI Clark,based on script by T Linderoth

#load programs we want to use
module purge
module load powertools
module load R/4.3.2-gfbf-2023a
module list 

EXEC='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/qualSummaryStats.R'
OUTREPORT='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_ALL_qc.bamstats.summary' 
OUTPLOT='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_ALL_qc_summary.pdf' 
IN_LIST='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/EMR_bamstats_list.txt'  # txt file containing full file path to merged vcfstats file 

CMD="$EXEC $IN_LIST $OUTREPORT $OUTPLOT 3 4 5 6 7 8 9" 
printf "\n%s\n\n" "$CMD"
eval $CMD

echo The date is $DATE


#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
