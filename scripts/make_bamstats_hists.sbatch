#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########

#SBATCH --time=12:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1         # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=400G            # memory required per allocated CPU (or core)
#SBATCH --job-name=vcf_stats_sum      # you can give your job a name for easier identification (same as -J)
#SBATCH --output=$HOME/EMR_WGS/log_vcf_stats_sum/${SLURM_JOB_NAME}_%A.out
#SBATCH --error=$HOME/EMR_WGS/log_vcf_stats_sum/${SLURM_JOB_NAME}_%A.err

##########

# load modules
module purge
module load powertools
module load GCC/8.3.0 OpenMPI/3.1.4
module load R/4.0.2
module list 

# define variables
EXEC='$HOME/EMR_WGS/scripts/makeBamstatsHists.R'
BAMSTATS='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/EMR_all_qc.bamstats'
OUTFILE='$HOME/EMR_WGS/variants/masks/bamstats_histograms.pdf'

# run code
CMD="$EXEC $BAMSTATS $OUTFILE"
printf "\n%s\n\n" "$CMD"
eval $CMD

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
seff ${SLURM_JOBID}
