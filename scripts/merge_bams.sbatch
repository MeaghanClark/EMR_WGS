#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########

#SBATCH --time=72:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=16       # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=8G            # memory required per allocated CPU (or core)
#SBATCH --job-name=merge_bams    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/home/clarkm89/EMR_WGS/logs/bamstats_merge/merge_%A.out"
#SBATCH --error="/mnt/home/clarkm89/EMR_WGS/logs/bamstats_merge/merge_%A.err" 

##########

# This script merges bam files 
# Last updated 06/22/2024 by MI Clark,based on script by T Linderoth
# Input: Reference genome with path, zipped bcf file
#
# Output: normalized zipped bcf file 

#load programs we want to use
module purge
module load SAMtools/1.18-GCC-12.3.0
module list 

bcftools --version

# define variables
REF='/mnt/research/Fitz_Lab/ref/massasauga/EMR_ref_2021/Scatenatus_HiC_v1.1.fasta'
BAMS='/mnt/research/FitzLab/projects/massasauga/WGS/scripts/keys/bam_list.txt' # make list of bamfiles, one file per line
OUTFILE='/mnt/scratch/clarkm89/EMR_WGS/bamstats' # put big BAM in scratch

if [ ! -d $OUTFILE ]; then mkdir $OUTFILE; fi

CMD="samtools merge -O BAM --reference $REFERENCE -b $BAMS -o $OUTFILE -@ $SLURM_CPUS_PER_TASK"

# run command 

printf "\n%s\n\n" "$CMD"

eval $CMD

wait

samtools index -@ $SLURM_CPUS_PER_TASK "$OUTFILE"


#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
#seff ${SLURM_JOBID}
