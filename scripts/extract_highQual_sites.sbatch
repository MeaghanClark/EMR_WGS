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

# extract_highQual_sites.sbatch
# M. Clark 09/22/2024, updated 10/8/2024

# create position file with sites (or SNPs) that pass quality filtering 

module purge
module load powertools
module load BCFtools/1.19-GCC-13.2.0
module list

bcftools --version 

# for variants:
#VCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/variants_noMAF/high_cov_inds/EMR_variants_nomaf_highcov_${SLURM_ARRAY_TASK_ID}.vcf.gz # all variants VCF, high coverage individuals
#OUTPOS=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/highQual_SNPs/EMR_highQual_varfilter_${SLURM_ARRAY_TASK_ID}.pos # get allsites varfilter

# for all sites:
VCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/allsites/high_qual_inds/EMR_allsites_highqual_${SLURM_ARRAY_TASK_ID}.vcf.gz
OUTPOS=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/highQual_allsites/EMR_highQual_allsites_${SLURM_ARRAY_TASK_ID}.pos # get allsites varfilter

EXCLUDE=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/windels/EMR_snps_in_deletions_nomaf_${SLURM_ARRAY_TASK_ID}.pos # excluding snps in deletions

bcftools view -H -f "PASS" -M2 -T ^"$EXCLUDE" -i 'INDEL=0 && N_PASS(GT[0,11,33,40,42,64,66,74,96,103,105,106,109,112,114,125,131,133,147,150,153,158,174,190,210]!="mis" & FMT/DP >= 10) >= 22 && N_PASS(GT[1,5,15,16,30,44,49,58,80,81,84,94,116,142,143,170,183,186,191,204,213,219,221]!="mis" & FMT/DP >= 10) >= 21 && N_PASS(GT[2,13,19,23,61,100,120,128,130,135,181,196]!="mis" & FMT/DP >= 10) >= 11 && N_PASS(GT[3,97,126,160]!="mis" & FMT/DP >= 10) >= 4 && N_PASS(GT[4,18,43,53,55,87,107,108,115,121,127,136,140,154,166,169,171,195,199,200,206,216,217]!="mis" & FMT/DP >= 10) >= 21 && N_PASS(GT[6,22,35,39,59,77,89,90,192]!="mis" & FMT/DP >= 10) >= 8 && N_PASS(GT[7,28,29,31,117,123,129,175,180,202]!="mis" & FMT/DP >= 10) >= 9 && N_PASS(GT[8,9,20,52,54,69,82,104,113,139,148,161,162,167,201,209]!="mis" & FMT/DP >= 10) >= 14 && N_PASS(GT[10,24,32,67,76,79,101,138,141,173,177,193,218]!="mis" & FMT/DP >= 10) >= 12 && N_PASS(GT[12,25,37,41,62,68,92,98,102,118,119,159,172,185,211,212]!="mis" & FMT/DP >= 10) >= 14 && N_PASS(GT[14,17,38,50,165,187,198,214]!="mis" & FMT/DP >= 10) >= 7 && N_PASS(GT[21,45,70,75,85,144,151,189]!="mis" & FMT/DP >= 10) >= 7 && N_PASS(GT[26,63]!="mis" & FMT/DP >= 10) >= 2 && N_PASS(GT[27,46,47,48,65,78,83,86,88,99,110,122,124,132,137,149,152,155,156,163,168,178,194,203,208]!="mis" & FMT/DP >= 10) >= 22 && N_PASS(GT[34,184]!="mis" & FMT/DP >= 10) >= 2 && N_PASS(GT[36,56]!="mis" & FMT/DP >= 10) >= 2 && N_PASS(GT[51,145,179]!="mis" & FMT/DP >= 10) >= 3 && N_PASS(GT[57,60,182]!="mis" & FMT/DP >= 10) >= 3 && N_PASS(GT[71,91,111,164,205,207]!="mis" & FMT/DP >= 10) >= 5 && N_PASS(GT[72,197]!="mis" & FMT/DP >= 10) >= 2 && N_PASS(GT[73]!="mis" & FMT/DP >= 10) >= 1 && N_PASS(GT[93,176,188]!="mis" & FMT/DP >= 10) >= 3 && N_PASS(GT[95,220]!="mis" & FMT/DP >= 10) >= 2 && N_PASS(GT[134]!="mis" & FMT/DP >= 10) >= 1 && N_PASS(GT[146]!="mis" & FMT/DP >= 10) >= 1 && N_PASS(GT[157]!="mis" & FMT/DP >= 10) >= 1 && N_PASS(GT[215]!="mis" & FMT/DP >= 10) >= 1' "$VCF" | perl -ne  '@tok = split(/\s+/,$_); if ($tok[7] =~ /REPGQ=(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),/) {print "$tok[0]\t$tok[1]\n" if ($1 >= 22 && $2 >= 21 && $3 >= 11 && $4 >= 4 && $5 >= 21 && $6 >= 8 && $7 >= 9 && $8 >= 14 && $9 >= 12 && $10 >= 14 && $11 >= 7 && $12 >= 7 && $13 >= 2 && $14 >= 22 && $15 >= 2 && $16 >= 2 && $17 >= 3 && $18 >= 3 && $19 >= 5 && $20 >= 2 && $21 >= 1 && $22 >= 3 && $23 >= 2 && $24 >= 1 && $25 >= 1 && $26 >= 1 && $27 >= 1);} else {print "$tok[0]\t$tok[1]\n";}' | uniq > "$OUTPOS"


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
