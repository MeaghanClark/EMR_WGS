#!/bin/bash

# Last updated 07/14/2023 by MI Clark,based on script by T Linderoth

#load programs we want to use
# don't purge modules, don't know how to load angsd separately... 
module purge
module load powertools
module load BCFtools/1.19-GCC-13.2.0
module list

IN_VCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/annotate_vcf_MI/EMR_MI_drop_norm_annotated_${SLURM_ARRAY_TASK_ID}.vcf.gz
OUT_VCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/biall_VCF_MI/EMR_MI_pass_biall_${SLURM_ARRAY_TASK_ID}.vcf.gz

bcftools view -f "PASS" -m 2 -M 2 -v snps -i 'F_PASS(FMT/DP>14) > 0.9 && F_PASS(FMT/GQ>14) > 0.9' -O z -o $OUT_VCF $IN_VCF

module purge 
module load tabixpp/1.1.2-GCC-12.3.0
module list

tabix -p vcf $OUT_VCF

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------

