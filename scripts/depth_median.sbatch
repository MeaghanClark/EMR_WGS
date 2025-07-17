#!/bin/bash --login
########## Define Resources Needed with SBATCH Lines ##########

#SBATCH --time=08:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --ntasks=1                  # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1           # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=50G                    # memory required per node - amount of memory (in bytes)
#SBATCH --job-name merge_bam      # you can give your job a name for easier identification (same as -J)
#SBATCH --output=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/median_vcf_%A.out
#SBATCH --error=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/median_vcf_%A.err
#SBATCH --account=bradburd
########## Command Lines to Run ##########



sort -n /mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/vcfstats/EMR_WGS_norm_ordered_depth.vcfstats | awk '{ a[NR] = $1 } END { if (NR % 2) { print a[(NR + 1) / 2] } else { print (a[NR / 2] + a[NR / 2 + 1]) / 2 } }' > /mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/vcfstats/median_depth.vcfstats

echo done 
