#!/bin/bash --login

# load modules
module purge
module load powertools
module load BCFtools/1.19-GCC-13.2.0
module list

bcftools --version

# define variables
MI_SAMPLES=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/MI_individuals.txt
IN_FILE=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/annotate_vcf/EMR_drop_norm_annotated_${SLURM_ARRAY_TASK_ID}.vcf.gz
OUT_FILE=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/annotate_vcf_MI/EMR_MI_drop_norm_annotated_${SLURM_ARRAY_TASK_ID}.vcf.gz

# run code
bcftools view --threads 4 --samples $MI_SAMPLES -o $OUT_FILE $IN_FILE

wait 

module purge
module load tabixpp/1.1.2-GCC-12.3.0
module list

tabix -p vcf $OUT_FILE


#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
