#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=12:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1         # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=200G            # memory required per allocated CPU (or core)
#SBATCH --job-name=vcfstats_depth     # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/vcfstats_sum/vcfstats_depth%A.out"
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/vcfstats_sum/vcfstats_depth%A.err"
#SBATCH --account=bradburd
##########

# load modules
module purge
module load powertools
module load R/4.3.2-gfbf-2023a
module list 

#find ${OUTFILE} > $OUTLIST # this line should crease a file OUTLIST that contains the path + name of OUTFILE 

# define variables
EXEC='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/qualDepth.R'
DEPTH_FILE='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/EMR_vcfstats_depth.txt'
ROBJ='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/EMR_vcfstats_depth.Robj' 
REPORT_FILE='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/EMR_drop_norm_vcfstats_depth.pdf' 

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
