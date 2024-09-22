#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########
# --time=168:00:00             # limit of wall clock time - how long the job will run (same as -t)
# --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
# --mem-per-cpu=20G            # memory required per allocated CPU (or core)
# --job-name=allsites_mask    # you can give your job a name for easier identification (same as -J)
# --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/allsites_mask/allsites_mask_%A.out" 
# --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/allsites_mask/allsites_mask_%A.err"
# --account=bradburd
##########
#^ Add "SBATCH" to run independently of wrapper script

# This script generates pos file of sites that pass quality control 
# Last updated 09/13/2024 by MI Clark,based on script by T Linderoth

# troubleshooting code: 
source /etc/profile
module -b list
### 

#load programs we want to use
module purge
module load powertools
module load Java/21.0.2
module load BCFtools/1.19-GCC-13.2.0
module load Perl-bundle-CPAN/5.38.0-GCCcore-13.2.0
module list

bcftools --version

VCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/annotated_vcf/EMR_annotated_${SLURM_ARRAY_TASK_ID}.vcf.gz
OUTPOS=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/allsites/EMR_qc_allsites_${SLURM_ARRAY_TASK_ID}.pos

# filtering pass: keep sites where 90% individuals in a population have at least 14 reads, and 90% of individuals in a population have a GQ more than 15

bcftools view -H -f "PASS" -i '
N_PASS(GT[0,13,50,59,64,100,102,113,140,151,153,154,160,167,172,185,191,193,214,218,222,229,250,268,295]!="mis" & FMT/DP >= 10) >= 24 && N_PASS(GT[1,5,18,19,35,46,66,75,89,123,124,127,138,175,207,208,244,260,263,270,285,298,307,311]!="mis" & FMT/DP >= 10) >= 23 && N_PASS(GT[2,15,24,30,97,147,180,188,190,197,258,275]!="mis" & FMT/DP >= 10) >= 11 && N_PASS(GT[3,142,186,231,308]!="mis" & FMT/DP >= 10) >= 5 && N_PASS(GT[4,23,65,79,83,90,130,155,159,174,181,187,198,205,224,238,242,245,274,278,281,288,303,304]!="mis" & FMT/DP >= 10) >= 23 && N_PASS(GT[6,29,52,58,92,120,132,133,271]!="mis" & FMT/DP >= 10) >= 9 && N_PASS(GT[7,44,47,54,84,88,157,164,195,269]!="mis" & FMT/DP >= 10) >= 10 && N_PASS(GT[8,42,43,48,176,183,189,251,257,283]!="mis" & FMT/DP >= 10) >= 10 && N_PASS(GT[9,10,26,78,81,107,125,152,168,204,215,232,233,239,247,282,294]!="mis" & FMT/DP >= 10) >= 16 && N_PASS(GT[11,33,49,103,115,122,149,203,206,249,253,272,306]!="mis" & FMT/DP >= 10) >= 12 && N_PASS(GT[12,22,61,137,161,241,252,265,289,302]!="mis" & FMT/DP >= 10) >= 10 && N_PASS(GT[14,36,55,62,98,105,135,143,150,177,178,230,246,262,296,297]!="mis" & FMT/DP >= 10) >= 15 && N_PASS(GT[16,32,57,63,82,96,158,179,223,310]!="mis" & FMT/DP >= 10) >= 10 && N_PASS(GT[17,21,56,76,237,264,277,300]!="mis" & FMT/DP >= 10) >= 8 && N_PASS(GT[20,25,34,37,38,72,94,99,171,194,280]!="mis" & FMT/DP >= 10) >= 10 && N_PASS(GT[27,31,45,104,116,145,173]!="mis" & FMT/DP >= 10) >= 7 && N_PASS(GT[28,68,108,114,128,209,219,266]!="mis" & FMT/DP >= 10) >= 8 && N_PASS(GT[39,67,87,112,118,202,255,290,305]!="mis" & FMT/DP >= 10) >= 9 && N_PASS(GT[40,70,71,74,101,121,126,129,131,144,162,182,184,192,200,216,220,225,226,234,240,254,273,284,292]!="mis" & FMT/DP >= 10) >= 24 && N_PASS(GT[41,86,93,148,169,170,227,248,259,267]!="mis" & FMT/DP >= 10) >= 10 && N_PASS(GT[51,119,156,165,210,212,221,261,293,312]!="mis" & FMT/DP >= 10) >= 10 && N_PASS(GT[53,60,69,80,85,95,141,235,243,286]!="mis" & FMT/DP >= 10) >= 10 && N_PASS(GT[73,77,106,111,136,166,211,256,279,299]!="mis" & FMT/DP >= 10) >= 10 && N_PASS(GT[91,117,146,196,199,201,217,228]!="mis" & FMT/DP >= 10) >= 8 && N_PASS(GT[109,134,163,236,287,291]!="mis" & FMT/DP >= 10) >= 6 && N_PASS(GT[110,276]!="mis" & FMT/DP >= 10) >= 2 && N_PASS(GT[139,309]!="mis" & FMT/DP >= 10) >= 2 && N_PASS(GT[213]!="mis" & FMT/DP >= 10) >= 1 && N_PASS(GT[301]!="mis" & FMT/DP >= 10) >= 1

' "$VCF" | perl -ne  '@tok = split(/\s+/,$_); if ($tok[7] =~ /REPGQ=(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),/) {print "$tok[0]\t$tok[1]\n" if ($1 >= 22 && $2 >= 21 && $3 >= 10 && $4 >= 4 && $5 >= 21 && $6 >= 8 && $7 >= 9 && $8 >= 15 && $9 >= 12 && $10 >= 9 && $11 >= 14 && $12 >= 9 && $13 >= 7 && $14 >= 10 && $15 >= 6 && $16 >= 7 && $17 >= 7 && $18 >= 21 && $19 >= 9 && $20 >= 7 && $21 >= 9 && $22 >= 8 && $23 >= 9 && $24 >= 7 && $25 >= 5 && $26 >= 2 && $27 >= 2 && $28 >= 1 && $29 >= 1);} else {print "$tok[0]\t$tok[1]\n";}' | uniq > "$OUTPOS"

angsd sites index "$OUTPOS"


#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
