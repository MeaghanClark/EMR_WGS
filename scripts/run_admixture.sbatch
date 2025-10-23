#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=72:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --array=1-27
#SBATCH --cpus-per-task=4     # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=50G            # memory required per allocated CPU (or core)
#SBATCH --job-name=admixture    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/admixture/admixture_%A-%a.out" 
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/admixture/admixture_%A-%a.err"
#SBATCH --account=bradburd
##########

# run_admixture.sbatch
# M. Clark 09/25/2024, updated 10/16/2025

# running admixture on range of K values defined using array job

module purge
module load ADMIXTURE/1.3.0
module load powertools
module list

# define variables 
BED='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/variants_highQual_indelMask/plink/LD_maf/EMR_ldPruned.bed'

# Usage: admixture <input file> <K>
admixture --cv -j${CPUS} $BED $SLURM_ARRAY_TASK_ID

wait

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
