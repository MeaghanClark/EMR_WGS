#!/bin/bash --login
########## SBATCH Lines for Resource Request ##########

#SBATCH --time=168:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1         # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=20G            # memory required per allocated CPU (or core)
#SBATCH --job-name=vcf_stats_sum      # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/home/clarkm89/EMR_WGS/log_vcf_stats_sum/vcf_stats_sum_%A.out"
#SBATCH --error="/mnt/home/clarkm89/EMR_WGS/log_vcf_stats_sum/vcf_stats_sum_%A.err"

##########

# load modules 
module purge
module load powertools
module load Java/21.0.2
module load BCFtools/1.19-GCC-13.2.0
module load Perl-bundle-CPAN/5.38.0-GCCcore-13.2.0
module list

EXEC='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/insertAnnotations_emr.pl' # need to customize vcf header descriptions for emr based on vcf summary stats
BCF='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/EMR_WGS_drop_norm.bcf.gz' # Merged bcf file! 
OUTFILE='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/annotate_vcf/EMR_drop_norm_annotated1.vcf.gz' # annotated VCF! 
GRPFILE='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/EMR_groups_qc.txt' #CHANGE
BEDFILE='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/EMR_mask_fail_sorted.bed' # output from gen_masks.sbatch, double check file name! 

CMD="bcftools view --no-version $BCF | $EXEC --dpbounds 1885,5656 --hetbound 1e-4 --bed $BEDFILE --overwrite --genorep $GRPFILE | bgzip > $OUTFILE" 

printf "\n%s\n\n" "$CMD"
eval $CMD
wait

module rm BCFtools/1.19-GCC-13.2.0 
module load tabixpp/1.1.2-GCC-12.3.0
module list

tabix -p vcf /mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/annotate_vcf/EMR_drop_norm_annotated1.vcf.gz

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
seff ${SLURM_JOBID}
