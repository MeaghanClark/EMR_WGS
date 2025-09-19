#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=168:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --array=1-200	
#SBATCH --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=48G            # memory required per allocated CPU (or core)
#SBATCH --job-name=pos_windel    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/pos_windel/pos_windel_%A_%a.out" 
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/pos_windel/pos_windel_%A_%a.err"
#SBATCH --account=bradburd
##########


# load modules 
module purge
module load BCFtools/1.19-GCC-13.2.0
module list

VCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/variants_noMAF/EMR_variants_nomaf_${SLURM_ARRAY_TASK_ID}.vcf.gz  
POS=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/windels/EMR_snps_in_deletions_nomaf_${SLURM_ARRAY_TASK_ID}.pos

bcftools view -i 'INFO/VT == "widel"' $VCF | bcftools query -f '%CHROM\t%POS\n' > $POS

### END SCRIPT
