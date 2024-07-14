#!/bin/bash

########## SBATCH Lines for Resource Request ##########
# --time=168:00:00             # limit of wall clock time - how long the job will run (same as -t)
# --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
# --mem-per-cpu=20G            # memory required per allocated CPU (or core)
# --job-name=var_mask    # you can give your job a name for easier identification (same as -J)
# --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/var_mask/var_mask_%A.out" 
# --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/var_mask/var_mask_%A.err"
# --account=bradburd
##########

# This script generates pos file of sites that pass quality control 
# Last updated 07/13/2023 by MI Clark,based on script by T Linderoth

#load programs we want to use
# don't purge modules, don't know how to load angsd separately... 
module purge
module load powertools
module load Java/21.0.2
module load BCFtools/1.19-GCC-13.2.0
module load Perl-bundle-CPAN/5.38.0-GCCcore-13.2.0
module list

bcftools --version

VCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/annotate_vcf/EMR_drop_norm_annotated_${SLURM_ARRAY_TASK_ID}.vcf.gz
OUTPOS=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/annotated/allsites/EMR_qc_allsites_${SLURM_ARRAY_TASK_ID}.pos


# filtering pass: keep sites where 100% individuals have at least 15X coverage, and 90% of individuals have a GC more than 15

bcftools view -H -f "PASS" -i 'N_PASS(GT!="mis" & FMT/DP > 14) >= 313' "$VCF" | perl -ne  '@tok = split(/\s+/,$_); if ($tok[7] =~ /REPGQ=(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),/) {print "$tok[0]\t$tok[1]\n" if ($1 >= 22 && $2 >= 12 && $3 >= 4 && $4 >= 22 && $5 >= 9 && $6 >= 9 && $7 >= 9 && $8 >= 10 && $9 >= 15 && $10 >= 22 && $11 >= 14 && $12 >= 9 && $13 >= 6 && $14 >= 22 && $15 >= 8 && $16 >= 11 && $17 >= 8 && $18 >= 9 && $19 >= 7 && $20 >= 9 && $21 >= 9 && $22 >= 9 && $23 >= 2 && $24 >= 7 && $25 >= 1 && $26 >= 7 && $27 >= 2 && $28 >= 5 && $29 >= 1);} else {print "$tok[0]\t$tok[1]\n";}' | uniq > "$OUTPOS"

# Site extraction command breakdown:

# Take only sites with FILTER=PASS, where neither the Z_SEX_DEPTH_BIAS or W_SEX_DEPTH_BIAS flag is present (=0), and for which 90% of individuals in each 
# Eaton, Country, City, East_West, Big_Valley, Eaton_x_Country, Country_x_East_West, 11, unknown, J67, After_Program class have non-missing genotypes and minimum DP of 4
# bcftools view -H -f "PASS" -i 'Z_SEX_DEPTH_BIAS=0 && W_SEX_DEPTH_BIAS=0 && N_PASS(GT[0,2,14,31]!="mis" & FMT/DP > 3) >= 4 && N_PASS(GT[1,4,5,6,7,8,9,11,13,15,18,19,20,23,25,28,30]!="mis" & FMT/DP > 3) >= 16 && N_PASS(GT[3,16]!="mis" & FMT/DP > 3) >= 2 && N_PASS(GT[10]!="mis" & FMT/DP > 3) >= 1 && N_PASS(GT[12]!="mis" & FMT/DP > 3) >= 1 && N_PASS(GT[17,24,27,29]!="mis" & FMT/DP > 3) >= 4 && N_PASS(GT[21,22,26,32,33,34]!="mis" & FMT/DP > 3) >= 6 && N_PASS(GT[35,36,40,41,44,46,47,49,53,54,59,60,70,72,73,74]!="mis" & FMT/DP > 3) >= 15 && N_PASS(GT[37,38,39]!="mis" & FMT/DP > 3) >= 3 && N_PASS(GT[42,43,45,48,50,51,52,55,56,57,58,68,69,71]!="mis" & FMT/DP > 3) >= 13 && N_PASS(GT[61,62,63,64,65,66,67,75,76]!="mis" & FMT/DP > 3) >= 9' "$VCF"

# If INFO/REPGQ flag is present require 90% of individuals in each Eaton, Country, City, East_West, Big_Valley, Eaton_x_Country, Country_x_East_West, 11, unknown, J67, After_Program class to have 
# a minimum genotype quality of 15 in order to retain site
# perl -ne  '@tok = split(/\s+/,$_); if ($tok[7] =~ /REPGQ=(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+)/) {print "$tok[0]\t$tok[1]\n" if ($1 >= 4 && $2 >= 16 && $3 >= 2 && $4 >= 1 && $5 >= 1 && $6 >= 4 && $7 >= 6 && $8 >= 15 && $9 >= 3 && $10 >= 13 && $11 >= 9);} else {print "$tok[0]\t$tok[1]\n";}'

# uniq is because some sites show up more than once in the VCF

angsd sites index "$OUTPOS"


#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
