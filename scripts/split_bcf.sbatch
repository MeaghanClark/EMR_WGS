#!/bin/bash

# This script splits a whole-genome bcf file into separate files based on chromosome coordinate files 

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=12:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=50G            # memory required per allocated CPU (or core)
#SBATCH --job-name=split_bcf    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/split_bcf/split_%A.out" 
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/split_bcf/split_%A.err"
#SBATCH --account=bradburd
##########

# load modules 
module purge
module load powertools
module load Java/21.0.2
module load BCFtools/1.19-GCC-13.2.0
module load Perl-bundle-CPAN/5.38.0-GCCcore-13.2.0
module list

# importing: OUTDIR=$outdir,CPUS=$cpus,BIG_BCF=$big_bcf,LOGFILESDIR=$logfilesdir,DATE=$date,CHROM_LIST_DIR=$chrom_list_dir \

# Input files
echo splitting ${BIG_BCF}

CHUNK_FILE=${CHROM_LIST_DIR}/chrom_list_${SLURM_ARRAY_TASK_ID}.txt

# Read the coordinate file line by line
while IFS= read -r REGION; do
    # Define the output file name
    OUTPUT_FILE="${OUTDIR}/EMR_WGS_drop_norm_${SLURM_ARRAY_TASK_ID}.bcf.gz"
    # Extract the region from the BCF file
    CMD="bcftools view -R $REGION_FILE -o $OUTPUT_FILE -O u $BIG_BCF"
    printf "\n%s\n\n" "$CMD"
    eval $CMD
	wait
done < "$CHUNK_FILE"

module rm BCFtools/1.19-GCC-13.2.0 
module load tabixpp/1.1.2-GCC-12.3.0
module list

# CHANGE FILE NAME
tabix -p vcf ${OUTDIR}/EMR_WGS_drop_norm_${SLURM_ARRAY_TASK_ID}.bcf.gz

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------

