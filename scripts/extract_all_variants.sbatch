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

VCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/annotate_vcf_MI/EMR_MI_drop_norm_annotated_${SLURM_ARRAY_TASK_ID}.vcf.gz
OUTPOS=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/annotated/allsites_MI/EMR_MI_qc_allsites_${SLURM_ARRAY_TASK_ID}.pos


# filtering pass: keep sites where 90% individuals have at least 15X coverage, and 90% of individuals have a GC more than 15, only Michigan individuals 

bcftools view -H -f "PASS" -i 'N_PASS(GT[0,11,22,33,44,55,66,77,88,99,104,105,106,107,108,109,110,111,125,136,147,158,169,180]!="mis" & FMT/DP > 14) >= 22 && N_PASS(GT[1,2,3,4,5,6,7,8,9,10,12,13,14]!="mis" & FMT/DP > 14) >= 12 && N_PASS(GT[15,16,17,18,19,20,21,23]!="mis" & FMT/DP > 14) >= 7 && N_PASS(GT[24,25,26,27,28,29,30,31,32,34,35,36,37,38,39,40]!="mis" & FMT/DP > 14) >= 14 && N_PASS(GT[41,42,43,45,46,47,48,49]!="mis" & FMT/DP > 14) >= 7 && N_PASS(GT[50,51,52,53,54,56]!="mis" & FMT/DP > 14) >= 5 && N_PASS(GT[57,58,59,60,61,62,63,64,65,67,68,69,70,71,72,73,74,75,76,78]!="mis" & FMT/DP > 14) >= 18 && N_PASS(GT[79,80,81,82,83,84,85,86,87,89,90,91]!="mis" & FMT/DP > 14) >= 11 && N_PASS(GT[92,93,94,95,96,97,98,100,101,102]!="mis" & FMT/DP > 14) >= 3 && N_PASS(GT[103]!="mis" & FMT/DP > 14) >= 1 && N_PASS(GT[112,113]!="mis" & FMT/DP > 14) >= 2 && N_PASS(GT[114]!="mis" & FMT/DP > 14) >= 1 && N_PASS(GT[115,116,117,118,119,120,121,122,123,124,126,127,128,129,130,131,132,133,134,135]!="mis" & FMT/DP > 14) >= 18 && N_PASS(GT[137,138,139,140,141,142,143,144,145,146,148,149,150,151,152,153,154]!="mis" & FMT/DP > 14) >= 15 && N_PASS(GT[155,156,157,159,160,161,162,163,164,165,166,167,168,170,171,172,173,174,175,176,177,178,179,181]!="mis" & FMT/DP > 14) >= 22 && N_PASS(GT[182,183,184,185,186,187,188,189,190]!="mis" & FMT/DP > 14) >= 8' "$VCF" | perl -ne  '@tok = split(/\s+/,$_); if ($tok[7] =~ /REPGQ=(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),/) {print "$tok[0]\t$tok[1]\n" if ($1 >= 18 && $2 >= 12 && $3 >= 0 && $4 >= 18 && $5 >= 0 && $6 >= 0 && $7 >= 0 && $8 >= 0 && $9 >= 15 && $10 >= 22 && $11 >= 14 && $12 >= 9 && $13 >= 0 && $14 >= 22 && $15 >= 0 && $16 >= 11 && $17 >= 8 && $18 >= 0 && $19 >= 7 && $20 >= 0 && $21 >= 0 && $22 >= 0 && $23 >= 1 && $24 >= 0 && $25 >= 1 && $26 >= 7 && $27 >= 2 && $28 >= 5 && $29 >= 0);} else {print "$tok[0]\t$tok[1]\n";}' | uniq > "$OUTPOS"


angsd sites index "$OUTPOS"


#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
