#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########

#SBATCH --time=72:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1         # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=400G            # memory required per allocated CPU (or core)
#SBATCH --job-name=vcf_stats_sum      # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/vcf_stats_sum/vcf_stats_sum_%A.out"
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/vcf_stats_sum/vcf_stats_sum_%A.err"
#SBATCH --account=bradburd

##########

# load modules
module purge
module load powertools
module load BCFtools/1.19-GCC-13.2.0
module list 

#find ${OUTFILE} > $OUTLIST # this line should crease a file OUTLIST that contains the path + name of OUTFILE 

# define variables
EXEC='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/qualSummaryStats.R'
OUTREPORT='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/EMR_drop_norm_rename.vcfstats.summary' 
OUTPLOT='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/EMR_drop_norm_rename_vcfstats_summary.pdf' 
OUTLIST='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/EMR_vcfstats_list.txt' 


# run code
CMD="$EXEC $OUTLIST $OUTREPORT $OUTPLOT 3 4 5 6 7 8 9 10 11 12 13 14" 
printf "\n%s\n\n" "$CMD"
eval $CMD


wait

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
seff ${SLURM_JOBID}
