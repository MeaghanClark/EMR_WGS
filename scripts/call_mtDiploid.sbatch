#!/bin/bash --login
########## SBATCH Lines for Resource Request ##########
#SBATCH --time=12:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=12G            # memory required per allocated CPU (or core)
#SBATCH --job-name=MT_test    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/MT_test/MT_test_%A.out" 
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/MT_test/MT_test_%A.err"
#SBATCH --account=bradburd
##########

#--------------- EXECUTABLE ---------------

# This script calls snps on the mt genome, but DIPLOID in order to quickly diagnose potential contamination issues
# Last updated 09/24/2024 by MI Clark, based on script by R Toczydlowski. Shout out to T Linderoth for helping establish reasonable SNP calling parameters
# Input: Reference genome path, bam file, input directory, output directory from wrapper-call_snps.sh 
#
# Output: ${OUTDIR}/${SAMPLE_NAME}.bcf  file, stored in directory at <storagenode>/<run_name>/called_snps
#			example: /mnt/home/clarkm89/massasauga/called_snps/PCC_321.bcf 

source /etc/profile

module -b list

echo we are starting calling snps!

#load programs we want to use, updated to ubuntu
module purge
module load powertools
module load BCFtools/1.19-GCC-13.2.0
module list 
 
bcftools --version


# Required import variables from wrapper
#	(1) reference
#	(2) list of bamfiles
#	(3) OUTDIR

# path to a file that contains the list of chromosomes for this array job no. 

# define variables 
REFERENCE='/mnt/scratch/clarkm89/EMR_ref_2024/GCA_039880765.1/GCA_039880765.1_rSisCat1_p1.0_genomic.fna'
LIST_OF_BAMFILES='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/final_bam_list.txt'
MT_CHROM='CM078157.1' # mt genome
SAMPLE_NAMES='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/final_bam_just_sample_names.txt'
OUTDIR=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/MT_test/
BCF_NAME=EMR_MT_calledDiploid
# NOT providing PLOIDYF 

# text for troubleshooting
echo using $REFERENCE 
echo I will put the output in ${OUTDIR}/${BCF_NAME}.bcf 

# make sure .bam files are indexed! 

# parameter recs from T Linderoth
 bcftools mpileup \
 -f $REFERENCE \
 -b $LIST_OF_BAMFILES \
 -r $MT_CHROM \
 -S $SAMPLE_NAMES \
 -C 0 \
 -d 10000 \
 -L 10000 \
 -q 20 \
 -Q 13 \
 --ns "UNMAP,SECONDARY,QCFAIL,DUP" \
 --nu "PROPER_PAIR" \
 -a "FORMAT/AD,FORMAT/DP,FORMAT/QS,FORMAT/SP,FORMAT/SCR,INFO/AD,INFO/SCR" \
 -p \
 -O u \
 | bcftools call \
 -a PV4,GQ,GP \
 -m \
 -P 0.002 \
 -O u \
 | bcftools +fill-tags \
 -O b \
 -o ${OUTDIR}/${BCF_NAME}.bcf.gz \
 -- -t 'AF,ExcHet,NS'

echo --FIN-- 


echo I have called SNPs using $LIST_OF_BAMFILES and $REFERENCE
echo I have also output a bcf file and saved it here: ${OUTDIR}/${BCF_NAME}.bcf

wait

tabix -p bcf ${OUTDIR}/${BCF_NAME}.bcf.gz

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------

