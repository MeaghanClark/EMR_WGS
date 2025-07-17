#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=168:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=10     # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=200G            # total memory required (or core)
#SBATCH --job-name=dist    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/dist/dist_%A.out" 
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/dist/dist_%A.err"
#SBATCH --account=bradburd
##########

# run_ngsDist.sbatch
# M. Clark, updated 09/27/2024
# Create genetic distance matrices from geno file

module purge
module load BCFtools/1.19-GCC-13.2.0
module load powertools
module list

EXEC=/mnt/research/Fitz_Lab/software/ngsDist/ngsDist
INPUTFILE=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/tree/distance/EMR_highQual_SNPs_nomaf_chrom_drop.geno.gz
OUTFILE=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/tree/distance/EMR_highQual_SNPs_nomaf_chrom_drop_full.dist

NIND=222
NSITES=2352466
REPS=100

$EXEC --n_threads 10 --verbose 1 --n_boot_rep $REPS --geno $INPUTFILE --n_ind $NIND --n_sites $NSITES --out $OUTFILE

wait 

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
