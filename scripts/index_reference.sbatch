#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=8:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1         # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=50G            # memory required per allocated CPU (or core)
#SBATCH --job-name=index      # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/index/index_ref_%A.out"
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/index/index_ref_%A.err"
#SBATCH --account=bradburd
##########


module purge
module load BWA/0.7.17-20220923-GCCcore-12.3.0
module list 


bwa index /mnt/scratch/clarkm89/EMR_ref_2024/GCA_039880765.1/GCA_039880765.1_rSisCat1_p1.0_genomic.fna

echo done indexing genome
