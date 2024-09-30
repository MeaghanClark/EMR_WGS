#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=168:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=20     # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=200G            # total memory required (or core)
#SBATCH --job-name=infer_trees    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/infer_trees/infer_trees_%A.out" 
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/infer_trees/infer_trees_%A.err"
#SBATCH --account=bradburd
##########

# infer_trees.sbatch
# M. Clark, updated 09/30/2024
# Infer neighbor joining trees from genetic distances 

module purge
module load powertools
module list

fastme -V

INPUTFILE=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/tree/distance/EMR_highQual_SNPs_nomaf_chrom_drop_full.dist
OUTFILE=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/tree/EMR_highQual_SNPs_nomaf_chrom_drop_full.nwk
DATASETS=101
CPUS=20

fastme -T $CPUS -i $INPUTFILE -s -D $DATASETS -v 3 -o $OUTFILE

wait 

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
