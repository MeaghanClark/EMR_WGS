#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########

#SBATCH --time=12:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1         # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=400G            # memory required per allocated CPU (or core)
#SBATCH --job-name=vcf_stats_sum      # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/home/clarkm89/EMR_WGS/log_vcf_stats_sum/vcf_stats_sum_%A.out"
#SBATCH --error="/mnt/home/clarkm89/EMR_WGS/log_vcf_stats_sum/vcf_stats_sum_%A.err"

##########

# load modules
module purge
module load powertools
module load GCC/8.3.0 OpenMPI/3.1.4
module load R/4.0.2
module list 

# define variables
EXEC='$HOME/EMR_WGS/scripts/qualSummaryStats.R'
STATLIST='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/EMR_vcfstats_list.txt'
OUTFILE='$HOME/EMR_WGS/variants/masks/EMR_norm.vcfstats.summary'

# run code
CMD="$EXEC $STATLIST $OUTFILE 3 4 5 6 7 8 9 10 11 12 13 14 15"
printf "\n%s\n\n" "$CMD"
eval $CMD

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
seff ${SLURM_JOBID}
