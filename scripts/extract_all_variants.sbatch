#!/bin/bash

########## SBATCH Lines for Resource Request ##########
# --time=168:00:00             # limit of wall clock time - how long the job will run (same as -t)
# --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
# --mem-per-cpu=20G            # memory required per allocated CPU (or core)
# --job-name=allsites_mask    # you can give your job a name for easier identification (same as -J)
# --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/allsites_mask/allsites_mask_%A.out" 
# --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/allsites_mask/allsites_mask_%A.err"
# --account=bradburd
##########

# This script generates pos file of sites that pass quality control 
# Last updated 07/15/2023 by MI Clark,based on script by T Linderoth

#load programs we want to use
module purge
module load powertools
module load Java/21.0.2
module load BCFtools/1.19-GCC-13.2.0
module load Perl-bundle-CPAN/5.38.0-GCCcore-13.2.0
module list

bcftools --version

VCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/annotate_vcf/EMR_drop_norm_annotated_${SLURM_ARRAY_TASK_ID}.vcf.gz
OUTPOS=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/allsites/EMR_qc_allsites_${SLURM_ARRAY_TASK_ID}.pos


# filtering pass: keep sites where 90% individuals have at least 4 reads, and 90% of individuals have a GC more than 15

bcftools view -H -f "PASS" -i 'N_PASS(GT[0,57,67,82,86,109,122,135,163,179,195,203,309]!="mis" & FMT/DP > 14) >= 12 && N_PASS(GT[1,127,170,222,315]!="mis" & FMT/DP > 14) >= 4 && N_PASS(GT[2,5,8,36,47,78,118,124,146,147,176,191,214,219,229,239,243,251,254,263,265,276,291,294,306]!="mis" & FMT/DP > 14) >= 22 && N_PASS(GT[3,38,40,48,66,75,141,153,181,272]!="mis" & FMT/DP > 14) >= 9 && N_PASS(GT[4,12,52,121,148,231,245,264,296,311]!="mis" & FMT/DP > 14) >= 9 && N_PASS(GT[6,23,50,53,65,89,142,165,213,316]!="mis" & FMT/DP > 14) >= 9 && N_PASS(GT[7,20,22,39,79,95,101,108,133,161]!="mis" & FMT/DP > 14) >= 9 && N_PASS(GT[9,14,29,49,77,91,103,115,119,167,187,198,206,207,215,238,242,247,256,257,273,286,301,313]!="mis" & FMT/DP > 14) >= 22 && N_PASS(GT[10,18,24,26,27,58,87,90,160,177,287]!="mis" & FMT/DP > 14) >= 10 && N_PASS(GT[11,21,37,44,68,81,92,114,125,128,151,178,211,249,252,258,274]!="mis" & FMT/DP > 14) >= 15 && N_PASS(GT[13,16,17,30,35,42,43,111,116,130,131,139,150,169,174,209,210,218,226,240,244,266,281,292]!="mis" & FMT/DP > 14) >= 22 && N_PASS(GT[15,84,93,97,100,143,144,171,186,192,221,241,262,271,277,278]!="mis" & FMT/DP > 14) >= 14 && N_PASS(GT[19,76,132,138,224,227,260,268,304,314]!="mis" & FMT/DP > 14) >= 9 && N_PASS(GT[25,61,71,73,106,117,149,152,156,172,183,190,193,194,212,233,235,280,282,295,297,299,303,305]!="mis" & FMT/DP > 14) >= 22 && N_PASS(GT[28,54,72,99,104,189,248,300,312]!="mis" & FMT/DP > 14) >= 8 && N_PASS(GT[31,34,56,63,112,137,157,164,204,228,267,290]!="mis" & FMT/DP > 14) >= 11 && N_PASS(GT[32,94,113,129,184,201,246,261,288]!="mis" & FMT/DP > 14) >= 8 && N_PASS(GT[33,70,85,136,158,159,216,237,253,269]!="mis" & FMT/DP > 14) >= 9 && N_PASS(GT[41,74,145,173,230,259,275,310]!="mis" & FMT/DP > 14) >= 7 && N_PASS(GT[45,105,140,154,197,200,208,255,285,302,317]!="mis" & FMT/DP > 14) >= 10 && N_PASS(GT[46,51,55,64,69,88,126,225,236,289]!="mis" & FMT/DP > 14) >= 9 && N_PASS(GT[59,62,96,98,120,155,199,250,284,307]!="mis" & FMT/DP > 14) >= 9 && N_PASS(GT[60,80]!="mis" & FMT/DP > 14) >= 2 && N_PASS(GT[83,102,134,162,182,185,188,205,217,270]!="mis" & FMT/DP > 14) >= 9 && N_PASS(GT[107]!="mis" & FMT/DP > 14) >= 1 && N_PASS(GT[110,123,166,175,196,223,234,298]!="mis" & FMT/DP > 14) >= 7 && N_PASS(GT[168,293]!="mis" & FMT/DP > 14) >= 2 && N_PASS(GT[180,202,220,232,279,283]!="mis" & FMT/DP > 14) >= 5 && N_PASS(GT[308]!="mis" & FMT/DP > 14) >= 1' "$VCF" | perl -ne  '@tok = split(/\s+/,$_); if ($tok[7] =~ /REPGQ=(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),/) {print "$tok[0]\t$tok[1]\n" if ($1 >= 12 && $2 >= 4 && $3 >= 22 && $4 >= 9 && $5 >= 9 && $6 >= 9 && $7 >= 9 && $8 >= 22 && $9 >= 10 && $10 >= 15 && $11 >= 22 && $12 >= 14 && $13 >= 9 && $14 >= 22 && $15 >= 8 && $16 >= 11 && $17 >= 8 && $18 >= 9 && $19 >= 7 && $20 >= 10 && $21 >= 9 && $22 >= 9 && $23 >= 2 && $24 >= 9 && $25 >= 1 && $26 >= 7 && $27 >= 2 && $28 >= 5 && $29 >= 1);} else {print "$tok[0]\t$tok[1]\n";}' | uniq > "$OUTPOS"

angsd sites index "$OUTPOS"


#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
