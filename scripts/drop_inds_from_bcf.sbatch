#!/bin/bash

########## SBATCH Lines for Resource Request ##########

#SBATCH --time=24:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=12G            # memory required per allocated CPU (or core)
#SBATCH --job-name=drop_inds    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/drop_inds/drop_%A.out"
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/drop_inds/drop_%A.err"
#SBATCH --account=bradburd

##########

# This script drops individuals using the bcftools -s tag 
# Last updated 06/28/2024 by MI Clark

#load programs we want to use, updated for ubuntu

module purge
module load powertools
module load BCFtools/1.19-GCC-13.2.0
module list 

bcftools --version

BCFLIST=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/rawBCF_list.txt
INDIR=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/rawBCF
OUTDIR=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/dropBCF

while read -r bcf_file; do

	# isolate bcf name
	BCF_NAME=$(echo "${bcf_file}" | cut -d "." -f 1)

	# drop individuals and resave 
	bcftools view -s ^KBPP_sca0242,KBPP_sca0144,KBPP_sca0180,ROME_sca0713,ROME_sca1395,SSSP_sca0979 \
	-o ${OUTDIR}/${BCF_NAME}_drop \
	-O b \
	${INDIR}/${bcf_file}
	
	# index bcf files 
	tabix -p bcf ${OUTDIR}/${BCF_NAME}_drop.bcf.gz

done < $BCFLIST

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------

