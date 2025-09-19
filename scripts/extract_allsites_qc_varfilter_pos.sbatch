#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=168:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --array=3-98
#SBATCH --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=95G            # memory required per allocated CPU (or core)
#SBATCH --job-name=ext_varfilter    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/ext_varfilter/ext_varfilter_%A-%a.out" 
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/ext_varfilter/ext_varfilter_%A-%a.err"
#SBATCH --account=bradburd
##########

VCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/annotate_vcf/EMR_drop_norm_annotated_${SLURM_ARRAY_TASK_ID}.vcf.gz # all sites VCF
EXCLUDE=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/windels/EMR_snps_in_deletions_nomaf_${SLURM_ARRAY_TASK_ID}.pos # excluding snps in deletions
OUTPOS=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/varfilter/EMR_qc_varfilter_allsites_${SLURM_ARRAY_TASK_ID}.pos # get allsites varfilter

bcftools view -H -f "PASS" -M2 -T ^"$EXCLUDE" -i 'INDEL=0 && N_PASS(GT[0,56,66,80,84,106,119,132,159,175,191,199,303]!="mis" & FMT/DP >=4) >= 12 && N_PASS(GT[1,124,166,218,309]!="mis" & FMT/DP >=4) >= 4 && N_PASS(GT[2,5,7,35,46,77,115,121,143,144,172,187,210,215,225,235,239,247,250,259,261,271,285,288,300]!="mis" & FMT/DP >=4) >= 22 && N_PASS(GT[3,37,39,47,65,74,138,150,177,267]!="mis" & FMT/DP >=4) >= 9 && N_PASS(GT[4,11,51,118,145,227,241,260,290,305]!="mis" & FMT/DP >=4) >= 9 && N_PASS(GT[6,22,49,52,64,87,139,161,209,310]!="mis" & FMT/DP >=4) >= 9 && N_PASS(GT[8,13,28,48,76,89,101,112,116,163,183,194,202,203,211,234,238,243,252,253,268,280,295,307]!="mis" & FMT/DP >=4) >= 22 && N_PASS(GT[9,17,23,25,26,57,85,88,157,173,281]!="mis" & FMT/DP >=4) >= 10 && N_PASS(GT[10,20,36,43,67,79,90,111,122,125,148,174,207,245,248,254,269]!="mis" & FMT/DP >=4) >= 15 && N_PASS(GT[12,15,16,29,34,41,42,108,113,127,128,136,147,165,170,205,206,214,222,236,240,262,276,286]!="mis" & FMT/DP >=4) >= 22 && N_PASS(GT[14,82,91,95,98,140,141,167,182,188,217,237,258,266,272,273]!="mis" & FMT/DP >=4) >= 14 && N_PASS(GT[18,75,129,135,220,223,256,264,298,308]!="mis" & FMT/DP >=4) >= 9 && N_PASS(GT[19,21,38,93,99,130,158]!="mis" & FMT/DP >=4) >= 6 && N_PASS(GT[24,60,70,72,104,114,146,149,153,168,179,186,189,190,208,229,231,275,277,289,291,293,297,299]!="mis" & FMT/DP >=4) >= 22 && N_PASS(GT[27,53,71,97,102,185,244,294,306]!="mis" & FMT/DP >=4) >= 8 && N_PASS(GT[30,33,55,62,109,134,154,160,200,224,263,284]!="mis" & FMT/DP >=4) >= 11 && N_PASS(GT[31,92,110,126,180,197,242,257,282]!="mis" & FMT/DP >=4) >= 8 && N_PASS(GT[32,69,83,133,155,156,212,233,249,265]!="mis" & FMT/DP >=4) >= 9 && N_PASS(GT[40,73,142,169,226,255,270,304]!="mis" & FMT/DP >=4) >= 7 && N_PASS(GT[44,103,137,151,193,196,204,251,296,311]!="mis" & FMT/DP >=4) >= 9 && N_PASS(GT[45,50,54,63,68,86,123,221,232,283]!="mis" & FMT/DP >=4) >= 9 && N_PASS(GT[58,61,94,96,117,152,195,246,279,301]!="mis" & FMT/DP >=4) >= 9 && N_PASS(GT[59,78]!="mis" & FMT/DP >=4) >= 2 && N_PASS(GT[81,100,131,178,181,184,201,213]!="mis" & FMT/DP >=4) >= 7 && N_PASS(GT[105]!="mis" & FMT/DP >=4) >= 1 && N_PASS(GT[107,120,162,171,192,219,230,292]!="mis" & FMT/DP >=4) >= 7 && N_PASS(GT[164,287]!="mis" & FMT/DP >=4) >= 2 && N_PASS(GT[176,198,216,228,274,278]!="mis" & FMT/DP >=4) >= 5 && N_PASS(GT[302]!="mis" & FMT/DP >=4) >= 1' "$VCF" | perl -ne  '@tok = split(/\s+/,$_); if ($tok[7] =~ /REPGQ=(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),/) {print "$tok[0]\t$tok[1]\n" if ($1 >= 12 && $2 >= 4 && $3 >= 22 && $4 >= 9 && $5 >= 9 && $6 >= 9 && $7 >= 22 && $8 >= 10 && $9 >= 15 && $10 >= 22 && $11 >= 14 && $12 >= 9 && $13 >= 6 && $14 >= 22 && $15 >= 8 && $16 >= 11 && $17 >= 8 && $18 >= 9 && $19 >= 7 && $20 >= 9 && $21 >= 9 && $22 >= 9 && $23 >= 2 && $24 >= 7 && $25 >= 1 && $26 >= 7 && $27 >= 2 && $28 >= 5 && $29 >= 1);} else {print "$tok[0]\t$tok[1]\n";}' | uniq > "$OUTPOS"

# Site extraction command breakdown:

# Take only sites with FILTER=PASS, for which 90% of individuals in each 
# population have non-missing genotypes and minimum DP of 4. INDEL=0 and -M2 removes putative indel and multiallelic sites. 
# -T ^$EXCLUDE removes any putative SNPs within indels.
# Tyler's original code: 
# bcftools view -H -f "PASS" -M2 -T ^"$EXCLUDE" -i 'INDEL=0 && Z_SEX_DEPTH_BIAS=0 && W_SEX_DEPTH_BIAS=0 && N_PASS(GT[0,2,14,31]!="mis" & FMT/DP > 3) >= 4 && N_PASS(GT[1,4,5,6,7,8,9,11,13,15,18,19,20,23,25,28,30]!="mis" & FMT/DP > 3) >= 16 && N_PASS(GT[3,16]!="mis" & FMT/DP > 3) >= 2 && N_PASS(GT[10]!="mis" & FMT/DP > 3) >= 1 && N_PASS(GT[12]!="mis" & FMT/DP > 3) >= 1 && N_PASS(GT[17,24,27,29]!="mis" & FMT/DP > 3) >= 4 && N_PASS(GT[21,22,26,32,33,34]!="mis" & FMT/DP > 3) >= 6 && N_PASS(GT[35,36,40,41,44,46,47,49,53,54,59,60,70,72,73,74]!="mis" & FMT/DP > 3) >= 15 && N_PASS(GT[37,38,39]!="mis" & FMT/DP > 3) >= 3 && N_PASS(GT[42,43,45,48,50,51,52,55,56,57,58,68,69,71]!="mis" & FMT/DP > 3) >= 13 && N_PASS(GT[61,62,63,64,65,66,67,75,76]!="mis" & FMT/DP > 3) >= 9' "$VCF"

# If INFO/REPGQ flag is present require 90% of individuals in populations to have 
# a minimum genotype quality of 15 in order to retain site
# Tyler's original code: 
# perl -ne  '@tok = split(/\s+/,$_); if ($tok[7] =~ /REPGQ=(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+)/) {print "$tok[0]\t$tok[1]\n" if ($1 >= 4 && $2 >= 16 && $3 >= 2 && $4 >= 1 && $5 >= 1 && $6 >= 4 && $7 >= 6 && $8 >= 15 && $9 >= 3 && $10 >= 13 && $11 >= 9);} else {print "$tok[0]\t$tok[1]\n";}' | uniq > "$OUTPOS"

# uniq is because some sites show up more than once in the VCF

angsd sites index "$OUTPOS"

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
