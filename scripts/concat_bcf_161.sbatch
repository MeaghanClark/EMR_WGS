#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########

#SBATCH --time=48:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=200G            # memory required per allocated CPU (or core)
#SBATCH --job-name=merge_161    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/merge_bcf/merge_161_%A.out"
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/merge_bcf/merge_161_%A.err"
#SBATCH --account=bradburd
#SBATCH --mail-type=ALL
#SBATCH --mail-user=clarkm89@msu.edu

##########

# This script merges called snps in genome chunk 161 with the rest of the genome-wide called snps. 

#load programs we want to use, updated for ubuntu
module purge
module load powertools
module load BCFtools/1.19-GCC-13.2.0
module list

# define variables
FILE1='/mnt/scratch/clarkm89/EMR_WGS/variants/EMR_WGS_raw.bcf.gz'
FILE2='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/EMR_WGS_161.bcf.gz'
OUTFILE='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/EMR_WGS_CompleteRaw.bcf.gz'
OUTFILE_SORTED='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/EMR_WGS_CompleteRawSorted.bcf.gz'
TEMP_DIR='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/temp_XXXXXX'

bcftools concat -a ${FILE1} ${FILE2} -Ob -o ${OUTFILE}

bcftools sort ${OUTFILE} -Ob -T ${TEMP_DIR} -m 190G -o ${OUTFILE_SORTED}

tabix -p bcf ${OUTFILE_SORTED}

wait

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------

