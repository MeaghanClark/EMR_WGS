#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########

#SBATCH --time=48:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1         # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=20G            # memory required per allocated CPU (or core)
#SBATCH --job-name=vcf_stats_sum      # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/home/clarkm89/EMR_WGS/log_vcf_stats_sum/vcf_stats_sum_%A.out"
#SBATCH --error="/mnt/home/clarkm89/EMR_WGS/log_vcf_stats_sum/vcf_stats_sum_%A.err"

##########

# load modules
module purge
module load Java/1.8.0_152 
module load bzip2/1.0.6 
module load zlib/1.2.11 
module load Boost/1.67.0
module load GCC/10.2.0 
module load GSL/2.6
module list

EXEC='/mnt/home/clarkm89/EMR_WGS/scripts/insertAnnotations_emr.pl' # need to customize vcf header descriptions for emr based on vcf summary stats
BCF="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/raw_calls/EMR_WGS_03222023_norm.bcf.gz" # Merged bcf file! 
BEDFILE='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/EMR_mask_fail.bed' # output from gen_masks.sbatch
OUTFILE="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/annotate_vcf/EMR_norm_annotated1.vcf.gz" # annotated VCF! 

## do I want to use a group file with the genorep flag to set bounds for different populations separately? 

# removed --genorep flag
CMD="bcftools view --no-version $BCF | $EXEC --dpbounds 118,352 --hetbound 1e-4 --bed $BEDFILE --overwrite | bgzip > $OUTFILE" #CHANGE dpbounds here! 


printf "\n%s\n\n" "$CMD"
eval $CMD
wait

tabix -p vcf $OUTFILE

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
seff ${SLURM_JOBID}
