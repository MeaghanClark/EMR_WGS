#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########

#SBATCH --time=12:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1         # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=20G            # memory required per allocated CPU (or core)
#SBATCH --job-name=vcf_stats_sum      # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/home/clarkm89/EMR_WGS/log_vcf_stats_sum/vcf_stats_sum_%A.out"
#SBATCH --error="/mnt/home/clarkm89/EMR_WGS/log_vcf_stats_sum/vcf_stats_sum_%A.err"

##########

# load modules
module purge
module load powertools
module load GCC/8.3.0 OpenMPI/3.1.4
module load R/4.0.2
module list 

EXEC='/mnt/home/clarkm89/EMR_WGS/scripts/insertAnnotations_emr.pl' # need to customize vcf header descriptions for emr 
BCF="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/raw_calls/EMR_WGS_03222023_norm.bcf.gz"
BEDFILE='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/EMR_mask_fail.bed'
OUTFILE="/mnt/gs21/scratch/lindero1/massasauga/EMR_WGS/annotate_vcf/EMR_norm_annotated1.vcf.gz"

# removed --genorep flag
CMD="bcftools view --no-version $BCF | $EXEC --dpbounds 118,352 --hetbound 1e-4 --bed $BEDFILE --overwrite | bgzip > $OUTFILE"


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
