#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########

#SBATCH --time=24:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=4	      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=50G            # memory required per allocated CPU (or core)
#SBATCH --job-name=vcf_stats      # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/reheader/reheader_%A.out"
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/reheader/reheader_%A.err"
#SBATCH --account=bradburd

##########

# load modules
module purge
module load powertools
module load BCFtools/1.19-GCC-13.2.0
module list 

bcftools --version

# define variables
# run code
CMD="bcftools reheader --threads 4 --samples /mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/bcf_rename_samples.txt -o ./EMR_WGS_drop_norm_rename.bcf.gz EMR_WGS_drop_norm.bcf.gz"

printf "\n%s\n\n" "$CMD"
eval $CMD

wait

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
seff ${SLURM_JOBID}
