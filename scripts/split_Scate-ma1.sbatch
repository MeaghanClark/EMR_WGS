#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=168:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --array=99-103
#SBATCH --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=48G            # memory required per allocated CPU (or core)
#SBATCH --job-name=split_chr1    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/split_chr1/split_chr1_%A-%a.out" 
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/split_chr1/split_chr1_%A-%a.err"
#SBATCH --account=bradburd
##########

IN_VCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/annotate_vcf/EMR_drop_norm_annotated_1.vcf.gz
SPLIT_VCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/annotate_vcf/EMR_drop_norm_annotated_${SLURM_ARRAY_TASK_ID}.vcf.gz
	
if [ $SLURM_ARRAY_TASK_ID == 99 ]; then
	REG="Scate-ma1:1-67287003"

elif [ $SLURM_ARRAY_TASK_ID == 100 ]; then
	REG="Scate-ma1:67287004-134574007"

elif [ $SLURM_ARRAY_TASK_ID == 101 ]; then
	REG="Scate-ma1:134574008-201861011"

elif [ $SLURM_ARRAY_TASK_ID == 102 ]; then
	REG="Scate-ma1:201861012-269148015"

elif [ $SLURM_ARRAY_TASK_ID == 103 ]; then
	REG="Scate-ma1:269148016-336435017"

else
    echo ERROR
    
fi

module purge
module load powertools
module load BCFtools/1.19-GCC-13.2.0
module list

bcftools view -r $REG -Oz -o $SPLIT_VCF $IN_VCF


module purge 
module load tabixpp/1.1.2-GCC-12.3.0
module list

tabix -p vcf $SPLIT_VCF


##### end script 
	

