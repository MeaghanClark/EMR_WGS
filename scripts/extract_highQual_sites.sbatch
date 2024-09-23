#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=4:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --array=1-200
#SBATCH --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=12G            # memory required per allocated CPU (or core)
#SBATCH --job-name=ext_HQ_var    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/ext_varfilter/ext_HQ_var_%A-%a.out" 
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/ext_varfilter/ext_HQ_var_%A-%a.err"
#SBATCH --account=bradburd
##########

# high_qual_snps_.sbatch
# M. Clark 09/22/2024, updated 09/22/2024

# filter to retain high coverage individuals for EMR WGS project
# retain individuals with 12X average genome-wide depth or greater

module purge
module load powertools
module load BCFtools/1.19-GCC-13.2.0
module list

bcftools --version 

VCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/variants_noMAF/high_cov_inds/EMR_variants_nomaf_highcov_${SLURM_ARRAY_TASK_ID}.vcf.gz # all variants VCF, high coverage individuals
EXCLUDE=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/windels/EMR_snps_in_deletions_nomaf_${SLURM_ARRAY_TASK_ID}.pos # excluding snps in deletions
OUTPOS=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/highQual_SNPs/EMR_highQual_varfilter_${SLURM_ARRAY_TASK_ID}.pos # get allsites varfilter

bcftools view -H -f "PASS" -M2 -T ^"$EXCLUDE" -i 'INDEL=0 && N_PASS(GT[0,11,34,41,43,65,67,75,98,105,107,108,111,115,117,128,134,136,150,153,156,161,178,194,216]!="mis" & FMT/DP >= 10) >= 22 && N_PASS(GT[1,5,15,16,31,45,50,59,82,83,86,96,119,145,146,174,187,190,195,209,219,225,227]!="mis" & FMT/DP >= 10) >= 21 && N_PASS(GT[2,13,19,23,62,102,123,131,133,138,185,200]!="mis" & FMT/DP >= 10) >= 11 && N_PASS(GT[3,99,129,163]!="mis" & FMT/DP >= 10) >= 4 && N_PASS(GT[4,18,44,54,56,89,109,110,118,124,130,139,143,157,170,173,175,199,203,205,211,222,223]!="mis" & FMT/DP >= 10) >= 21 && N_PASS(GT[6,22,36,40,60,79,91,92,196]!="mis" & FMT/DP >= 10) >= 8 && N_PASS(GT[7,29,30,32,120,126,132,179,184,207]!="mis" & FMT/DP >= 10) >= 9 && N_PASS(GT[8,9,20,53,55,70,84,106,116,142,151,164,165,171,206,215]!="mis" & FMT/DP >= 10) >= 14 && N_PASS(GT[10,24,33,68,77,81,103,141,144,177,181,197,224]!="mis" & FMT/DP >= 10) >= 12 && N_PASS(GT[12,25,38,42,63,69,94,100,104,121,122,162,176,189,217,218]!="mis" & FMT/DP >= 10) >= 14 && N_PASS(GT[14,17,39,51,169,191,202,220]!="mis" & FMT/DP >= 10) >= 7 && N_PASS(GT[21,46,71,76,87,147,154,193]!="mis" & FMT/DP >= 10) >= 7 && N_PASS(GT[26,64,204]!="mis" & FMT/DP >= 10) >= 3 && N_PASS(GT[27,47,48,49,66,80,85,88,90,101,112,125,127,135,140,152,155,158,159,166,172,182,198,208,213]!="mis" & FMT/DP >= 10) >= 22 && N_PASS(GT[28,58,61,186]!="mis" & FMT/DP >= 10) >= 4 && N_PASS(GT[35,78,114,188,214]!="mis" & FMT/DP >= 10) >= 4 && N_PASS(GT[37,57,167]!="mis" & FMT/DP >= 10) >= 3 && N_PASS(GT[52,148,183]!="mis" & FMT/DP >= 10) >= 3 && N_PASS(GT[72,93,113,168,210,212]!="mis" & FMT/DP >= 10) >= 5 && N_PASS(GT[73,201]!="mis" & FMT/DP >= 10) >= 2 && N_PASS(GT[74]!="mis" & FMT/DP >= 10) >= 1 && N_PASS(GT[95,180,192]!="mis" & FMT/DP >= 10) >= 3 && N_PASS(GT[97,226]!="mis" & FMT/DP >= 10) >= 2 && N_PASS(GT[137]!="mis" & FMT/DP >= 10) >= 1 && N_PASS(GT[149]!="mis" & FMT/DP >= 10) >= 1 && N_PASS(GT[160]!="mis" & FMT/DP >= 10) >= 1 && N_PASS(GT[221]!="mis" & FMT/DP >= 10) >= 1' "$VCF" | perl -ne  '@tok = split(/\s+/,$_); if ($tok[7] =~ /REPGQ=(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),/) {print "$tok[0]\t$tok[1]\n" if ($1 >= 22 && $2 >= 21 && $3 >= 11 && $4 >= 4 && $5 >= 21 && $6 >= 8 && $7 >= 9 && $8 >= 14 && $9 >= 12 && $10 >= 14 && $11 >= 7 && $12 >= 7 && $13 >= 3 && $14 >= 22 && $15 >= 4 && $16 >= 4 && $17 >= 3 && $18 >= 3 && $19 >= 5 && $20 >= 2 && $21 >= 1 && $22 >= 3 && $23 >= 2 && $24 >= 1 && $25 >= 1 && $26 >= 1 && $27 >= 1);} else {print "$tok[0]\t$tok[1]\n";}' | uniq > "$OUTPOS"

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
