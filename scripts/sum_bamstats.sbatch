#!/bin/bash

########## SBATCH Lines for Resource Request ##########

#SBATCH --time=48:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=120G            # memory required per allocated CPU (or core)
#SBATCH --job-name=sum_bamstats    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/home/clarkm89/EMR_WGS/log_bamstats_hists/annotations_hist_%A.out" # CHANGE
#SBATCH --error="/mnt/home/clarkm89/EMR_WGS/log_bamstats_hists/annotations_hist_%A.err" # CHANGE

##########

# This script reads bamstats files into R, calculates a summary, and outputs a .pdf report containing histograms of stats
# Last updated 05/22/2024 by MI Clark, based on script by T Linderoth

#load programs we want to use
module purge
module load powertools
module load GCC/8.3.0 OpenMPI/3.1.4
module load R/4.0.2
module list 

bcftools --version

# define variables
EXEC='/mnt/research/Fitz_Lab/projects/mosaic/variants/masks/qualSummaryStats.R' # CHANGE ALL OF THESE!!!! 
STATLIST='/mnt/research/Fitz_Lab/projects/posk/variants/masks/mi_posk_bamstats_list.txt' # list containing (probably) 1 merged bamstats filename
OUTFILE_SUM='/mnt/research/Fitz_Lab/projects/posk/variants/masks/mi_posk_all_qc.bamstats.summary' # summary output 
OUTFILE_HIST='/path/to/where/you/want/pdf/hist/output.pdf'

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
seff ${SLURM_JOBID}
