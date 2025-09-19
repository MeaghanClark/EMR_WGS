#!/bin/bash

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=24:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --array=1-192
#SBATCH --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=12G            # memory required per allocated CPU (or core)
#SBATCH --job-name=map_stats_reseq    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/map_stats/bam_map_stats_%A-%a.out" 
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/map_stats/bam_map_stats_%A-%a.err"
#SBATCH --account=bradburd

module purge
module load powertools
module load BCFtools/1.19-GCC-13.2.0
module load Perl-bundle-CPAN/5.38.0-GCCcore-13.2.0
module list

BAMLIST=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/bam_list_reseq.txt
BAM=$(awk "NR==${SLURM_ARRAY_TASK_ID}" $BAMLIST)

BASE_FILE=$(echo "${BAM}" | cut -d "/" -f 8) 
IND_NAME=$(echo "${BASE_FILE}" | cut -d "." -f 1) 
OUTDIR=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/alignments/mapping_stats/reseq
echo running samtools stat on $IND_NAME

samtools stats $BAM  > ${OUTDIR}/${IND_NAME}.trim.bam_mapping_stats.txt

wait

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------

