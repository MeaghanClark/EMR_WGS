#!/bin/bash

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=48:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --array=1-98
#SBATCH --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=48G            # memory required per allocated CPU (or core)
#SBATCH --job-name=bam_depth    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/bam_depth/bam_depth%A.out" 
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/bam_depth/bam_depth%A.err"
#SBATCH --account=bradburd

module purge
module load powertools
module load SAMtools/1.18-GCC-12.3.0
module list

BAMLIST=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/bam_list.txt
SCAF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/scaf_names.txt

REG=$(awk "NR==${SLURM_ARRAY_TASK_ID}" $SCAF)

OUTDIR=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/alignments/bam_coverage

samtools coverage -b $BAMLIST -r $REG > ${OUTDIR}/${REG}_mapping_stats.txt

wait

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------

