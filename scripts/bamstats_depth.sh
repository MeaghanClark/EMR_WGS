#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=12:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1         # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=300G            # memory required per allocated CPU (or core)
#SBATCH --job-name=bamstats_depth     # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/bamstats_sum/bamstats_depth_%A.out"
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/bamstats_sum/bamstats_depth_%A.err"
#SBATCH --account=bradburd
##########

# load modules
module purge
module load powertools
module load R/4.3.2-gfbf-2023a
module list 


# define variables
EXEC='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/qualDepth.R'
DEPTH_FILE='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_ALL_qc_depth.bamstats'
ROBJ='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_ALL_bamstats_depth.Robj' 
REPORT_FILE='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_ALL_qc_depth.pdf' 

# run code
CMD="$EXEC $DEPTH_FILE $ROBJ $REPORT_FILE" 
printf "\n%s\n\n" "$CMD"
eval $CMD


wait

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
