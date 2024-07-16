#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=168:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --array=2-98
#SBATCH --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=48G            # memory required per allocated CPU (or core)
#SBATCH --job-name=ext_var_nomaf    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/ext_var_nomaf/ext_var_nomaf_%A.out" 
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/ext_var_nomaf/ext_var_nomaf_%A.err"
#SBATCH --account=bradburd
##########

EXEC='/mnt/research/Fitz_Lab/projects/posk/variants/vcf/scripts/extractVariants.pl'
VCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/annotate_vcf/EMR_drop_norm_annotated_${SLURM_ARRAY_TASK_ID}.vcf.gz # annotated allsites VCF
OUTVCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/variants_noMAF/EMR_variants_nomaf_${SLURM_ARRAY_TASK_ID}.vcf.gz  # nomaf variant sites VCF

CMD="$EXEC --skip_af $VCF | bgzip > $OUTVCF"

printf "\n%s\n\n" "$CMD"
eval $CMD
wait

tabix -p vcf $OUTVCF

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------