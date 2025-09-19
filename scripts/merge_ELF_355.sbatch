#!/bin/bash
########## Define Resources Needed with SBATCH Lines ##########

#SBATCH --time=08:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --ntasks=1                  # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=8G                    # memory required per node - amount of memory (in bytes)
#SBATCH --job-name merge_ELF335_bam      # you can give your job a name for easier identification (same as -J)
#SBATCH --output=/mnt/home/clarkm89/EMR_WGS/logs/ELF_335_merge/merge_%A.out
#SBATCH --error=/mnt/home/clarkm89/EMR_WGS/logs/ELF_335_merge/merge_%A.err
#SBATCH --account=bradburd
########## Command Lines to Run ##########

#this script merges .bam files into one. 

# Last updated 06/22/2024 by MI Clark, based on script by B Reid
# inputs and outputs are specified in the script; output will be in ./alignments

module load SAMtools/1.18-GCC-12.3.0

path="/mnt/scratch/clarkm89/EMR_WGS/alignments/"

samtools merge ${path}/ELF_335.trim.bam ${path}/ELF_335L2.trim.bam ${path}/ELF_335L3.trim.bam

echo I have merged the files!

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
#seff ${SLURM_JOBID}

