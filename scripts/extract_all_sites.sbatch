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
N_PASS(GT[0,12,48,57,62,96,98,109,135,146,148,154,161,166,178,183,185,206,210,214,221,242,260,286]!="mis" & FMT/DP >= 15) >= 22 && 
N_PASS(GT[1,5,17,18,34,44,64,73,86,119,120,122,133,199,200,236,252,255,262,277,289,297,301]!="mis" & FMT/DP >= 15) >= 21 && 
N_PASS(GT[2,14,23,29,93,142,173,181,189,250,267]!="mis" & FMT/DP >= 15) >= 10 && 
N_PASS(GT[3,137,179,223,298]!="mis" & FMT/DP >= 15) >= 4 && 
N_PASS(GT[4,22,63,77,80,125,149,153,168,174,180,190,197,216,230,234,237,266,270,273,280,294,295]!="mis" & FMT/DP >= 15) >= 21 && 
N_PASS(GT[6,28,50,56,88,116,127,128,263]!="mis" & FMT/DP >= 15) >= 8 && 
N_PASS(GT[7,41,42,46,169,176,182,243,249,275]!="mis" & FMT/DP >= 15) >= 9 && 
N_PASS(GT[8,9,25,76,78,103,121,147,162,196,207,224,225,231,239,274,285]!="mis" & FMT/DP >= 15) >= 15 && N_PASS(GT[10,32,47,99,111,118,144,195,198,241,245,264,296]!="mis" & FMT/DP >= 15) >= 12 && N_PASS(GT[11,21,59,132,155,233,244,257,281,293]!="mis" & FMT/DP >= 15) >= 9 && N_PASS(GT[13,35,53,60,94,101,130,138,145,170,171,222,238,254,287,288]!="mis" & FMT/DP >= 15) >= 14 && N_PASS(GT[15,31,55,61,79,92,152,172,215,300]!="mis" & FMT/DP >= 15) >= 9 && N_PASS(GT[16,20,54,74,229,256,269,291]!="mis" & FMT/DP >= 15) >= 7 && N_PASS(GT[19,24,33,36,37,70,90,95,165,186,272]!="mis" & FMT/DP >= 15) >= 10 && N_PASS(GT[26,30,43,100,112,140,167]!="mis" & FMT/DP >= 15) >= 6 && N_PASS(GT[27,66,104,110,123,201,211,258]!="mis" & FMT/DP >= 15) >= 7 && N_PASS(GT[38,65,84,108,114,194,247,282]!="mis" & FMT/DP >= 15) >= 7 && N_PASS(GT[39,68,69,72,97,117,124,126,139,156,175,177,184,192,208,212,217,218,226,232,246,265,276]!="mis" & FMT/DP >= 15) >= 21 && N_PASS(GT[40,83,89,143,163,164,219,240,251,259]!="mis" & FMT/DP >= 15) >= 9 && N_PASS(GT[45,52,81,85,151,158,187,261]!="mis" & FMT/DP >= 15) >= 7 && N_PASS(GT[49,115,150,159,202,204,213,253,284,302]!="mis" & FMT/DP >= 15) >= 9 && N_PASS(GT[51,58,67,82,91,136,227,235,278]!="mis" & FMT/DP >= 15) >= 8 && N_PASS(GT[71,75,102,107,131,160,203,248,271,290]!="mis" & FMT/DP >= 15) >= 9 && N_PASS(GT[87,113,141,188,191,193,209,220]!="mis" & FMT/DP >= 15) >= 7 && N_PASS(GT[105,129,157,228,279,283]!="mis" & FMT/DP >= 15) >= 5 && N_PASS(GT[106,268]!="mis" & FMT/DP >= 15) >= 2 && N_PASS(GT[134,299]!="mis" & FMT/DP >= 15) >= 2 && N_PASS(GT[205]!="mis" & FMT/DP >= 15) >= 1 && N_PASS(GT[292]!="mis" & FMT/DP >= 15) >= 1' "$VCF" | perl -ne  '@tok = split(/\s+/,$_); if ($tok[7] =~ /REPGQ=(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),/) {print "$tok[0]\t$tok[1]\n" if ($1 >= 22 && $2 >= 21 && $3 >= 10 && $4 >= 4 && $5 >= 21 && $6 >= 8 && $7 >= 9 && $8 >= 15 && $9 >= 12 && $10 >= 9 && $11 >= 14 && $12 >= 9 && $13 >= 7 && $14 >= 10 && $15 >= 6 && $16 >= 7 && $17 >= 7 && $18 >= 21 && $19 >= 9 && $20 >= 7 && $21 >= 9 && $22 >= 8 && $23 >= 9 && $24 >= 7 && $25 >= 5 && $26 >= 2 && $27 >= 2 && $28 >= 1 && $29 >= 1);} else {print "$tok[0]\t$tok[1]\n";}' | uniq > "$OUTPOS"

angsd sites index "$OUTPOS"


#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
