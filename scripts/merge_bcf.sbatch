#!/bin/bash

########## SBATCH Lines for Resource Request ##########

#SBATCH --time=12:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=12G            # memory required per allocated CPU (or core)
#SBATCH --job-name=merge_bcf    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/home/clarkm89/EMR_WGS/log_bamstats_hists/annotations_hist_%A.out" # CHANGE
#SBATCH --error="/mnt/home/clarkm89/EMR_WGS/log_bamstats_hists/annotations_hist_%A.err" # CHANGE

##########

# This script merges bcf files into a single file
# Last updated 05/22/2024 by MI Clark, based on script by T Linderoth

#load programs we want to use
module purge
module load powertools
module load GCC/10.2.0
module load GSL/2.6
module list 

bcftools --version

# define variables
INDIR='/path/to/bcf/files/from/norm_vcf'
INFILE1='file1.bcf.gz' 
INFILE2='file1.bcf.gz'
# and so on for length(chrom_list)
OUTFILE='/mnt/gs21/scratch/lindero1/posk/mask/mi_posk_all_qc.bam' # change to where output should go

CMD="bcftools concat -o $OUTFILE -Ob $INFILE1 $INFILE2"

# run command 

printf "\n%s\n\n" "$CMD"

eval $CMD

wait



