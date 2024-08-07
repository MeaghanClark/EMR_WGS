#!/bin/bash
		
# wrapper-normalize_variants.sh		
# This script starts an array job normalize variants in raw bcf files
# The array job will start one job per BCF in bcflist
# Last updated 07/01/2024 by MI Clark, script format inspired by R Toczydlowski 

#  run from project directory (where you want output directory to be created)


# define high level vars
jobname=bcf_norm
date=$(date +%m%d%Y)

#define dirs:
logfilesdir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/${jobname} 
#chrom_list_dir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/chrom 
indir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/
outdir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/

# define slurm job details
cpus=4
total_mem=48G
#array_no=$(ls $chrom_list_dir | wc -l) #***

# define executable and reference files
reference=/mnt/research/Fitz_Lab/ref/massasauga/EMR_ref_2021/Scatenatus_HiC_v1.1.fasta 
executable=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/normalize_variants.sbatch

#check if logfiles directory has been created in submit dir yet; if not, make one
if [ ! -d $logfilesdir ]; then mkdir $logfilesdir; fi
if [ ! -d $outdir ]; then mkdir $outdir; fi

sbatch --job-name=$jobname \
		--export=REFERENCE=$reference,CPUS=$cpus,RUN_NAME=$run_name,LOGFILESDIR=$logfilesdir,DATE=$date,INDIR=$indir,OUTDIR=$outdir \
		--cpus-per-task=$cpus \
		--mem=$total_mem \
		--output=$logfilesdir/${jobname}_${date}_%A-%a.out \
		--error=$logfilesdir/${jobname}_${date}_%A-%a.err \
		--time=72:00:00 \
		--account=bradburd \
		$executable

echo I submitted to normalize my bcf files!
echo ----------------------------------------------------------------------------------------

