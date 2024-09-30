#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=12:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --array=1-4
#SBATCH --cpus-per-task=1       # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=50G            # memory required per allocated CPU (or core)
#SBATCH --job-name=id_roh     # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/roh/id_roh_%A-%a.out"
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/roh/id_roh_%A-%a.err"
#SBATCH --account=bradburd
##########

# run_bcftools_roh.sbatch
# M. Clark, 09/30/2024
# based on code by T. Linderoth, rohRegions.pl also written by T. Linderoth. Thanks Tyler! 

FILE_LIST='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/roh_list.txt' # list of bcftools roh output files, one per line
FILE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$FILE_LIST") # pull out a line from the list of files based on the array number 
REGION_OUT=$(echo "$FILE" | sed 's/\.txt$/\.regions/') # replace .txt with .regions, defines region output 
FROH_OUT=$(echo "$FILE" | sed 's/\.txt$/\.froh/') # replace .txt with .froh, defines Froh output 
EXEC='/mnt/research/Fitz_Lab/projects/mosaic/popgen/roh/scripts/rohRegions.pl' # perl script

CMD="$EXEC 20 $HMMF $REGION_OUT > $FROH_OUT"

printf "\n%s\n\n" "$CMD"

eval $CMD

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
