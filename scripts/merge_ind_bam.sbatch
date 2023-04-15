#!/bin/bash
########## Define Resources Needed with SBATCH Lines ##########

#SBATCH --time=08:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --ntasks=1                  # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=8G                    # memory required per node - amount of memory (in bytes)
#SBATCH --job-name merge_bam      # you can give your job a name for easier identification (same as -J)
#SBATCH --output=./logfiles_aligntogenome/merge_bam_%A.out
#SBATCH --error=./logfiles_aligntogenome/merge_bam_%A.err
########## Command Lines to Run ##########

#this script merges .bam files into one. 

		# Last updated 04/27/2020 by MI Clark, based on script by B Reid
# inputs and outputs are specified in the script; output will be in ./alignments

module load OpenMPI/2.1.1
module load GCC/6.4.0-2.28
module load SAMtools

path=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS_alignments_02282023
samtools merge ${path}/ELF_335_MG.rmdup.bam ${path}/ELF_335_L2.rmdup.bam ${path}/ELF_335_L3.rmdup.bam

echo I have merged the files!

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
seff ${SLURM_JOBID}
