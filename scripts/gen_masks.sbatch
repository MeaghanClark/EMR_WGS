#!/bin/bash

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=48:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=48G            # memory required per allocated CPU (or core)
#SBATCH --job-name=gen_masks    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/gen_mask/gen_mask_%A.out" 
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/gen_mask/gen_mask_%A.err"
#SBATCH --account=bradburd
##########

# This script generates bed file of site masks based on bam statistics
# Last updated 05/18/2023 by MI Clark,based on script by T Linderoth

#load programs we want to use
module purge
module load powertools
module list 


# define variables 
EXEC=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/bedmask.pl
BAMSTATS=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_ALL_qc.bamstats
OUTPREFIX=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/EMR_mask
REPORT=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/EMR_mask_report.txt

### create bed file of masks

echo The date is $DATE

CMD="$EXEC --mindepth 1885 --maxdepth 5656 --minmq 35 --maxmq0 0.1 --minbq 20 --maxbq0 0.1 $BAMSTATS $OUTPREFIX > $REPORT" # update filtering values based on bamstats summaries

# changed parameters based on output from make_bamstats_hists

printf "\n%s\n\n" "$CMD"
eval $CMD


#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
