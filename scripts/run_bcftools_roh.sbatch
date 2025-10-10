#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=24:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --array=1-222
#SBATCH --cpus-per-task=4        # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=50G            # memory required per allocated CPU (or core)
#SBATCH --job-name=bcf_roh     # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/roh/bcf_roh_%A-%a.out"
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/roh/bcf_roh_%A-%a.err"
#SBATCH --account=bradburd
##########
# run_bcftools_roh.sbatch
# M. Clark, 09/30/2024, updated 09/19/2024

#load programs we want to use
module purge
module load powertools
module load BCFtools/1.19-GCC-13.2.0
module list

bcftools --version

# define variable 
ARRAY_KEY=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/roh_key.txt

# use key file to get individual id and allele freq file 
line=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$ARRAY_KEY")

IFS=$' ' read -r IND AF_FILE <<< "$line"
echo individual is $IND
echo using allele freq file $AF_FILE

# define other variables 
VCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/variants_highQual_indelMask/EMR_highQual_variants_nomaf_indelBuf_chrom.vcf.gz
OUTPUT=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/roh/raw_roh_output/${IND}_highQual_SNPs_nomaf_chrom_drop_roh.txt
CPUS=4

bcftools roh --samples $IND --threads $CPUS --rec-rate 3.935e-8 --AF-file $AF_FILE --output-type sr --skip-indels --viterbi-training 1e-10 --output $OUTPUT $VCF 


#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
