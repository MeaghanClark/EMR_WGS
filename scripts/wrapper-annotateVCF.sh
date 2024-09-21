#!/bin/bash
		
# wrapper-annotateVCF.sh		
# This script starts an array job to annotate 
# The array job will start one job per BCF in bcflist
# Last updated 09/12/2024 by MI Clark, script format inspired by R Toczydlowski 

#  run from project directory (where you want output directory to be created)

# define high level vars
jobname=annotateVCF
date=$(date +%m%d%Y)

#define dirs:
logfilesdir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/${jobname} 
chrom_list_dir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/chrom_200
indir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/
outdir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/

# define slurm job details
cpus=1
total_mem=12G
array_no=$(ls $chrom_list_dir | wc -l) #***

# define executable and reference files
executable=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/annotateVCF.sh

#check if logfiles directory has been created in submit dir yet; if not, make one
if [ ! -d $logfilesdir ]; then mkdir $logfilesdir; fi
if [ ! -d $outdir ]; then mkdir $outdir; fi

sbatch --job-name=$jobname \
		--array=1-$array_no \
		--export=CPUS=$cpus,RUN_NAME=$run_name,CHROM_LIST_DIR=$chrom_list_dir,LOGFILESDIR=$logfilesdir,DATE=$date,INDIR=$indir,OUTDIR=$outdir \
		--cpus-per-task=$cpus \
		--mem=$total_mem \
		--output=$logfilesdir/${jobname}_${date}_%A-%a.out \
		--error=$logfilesdir/${jobname}_${date}_%A-%a.err \
		--time=12:00:00 \
		--account=bradburd \
		$executable

echo I submitted to annotate my bcf file!
echo ----------------------------------------------------------------------------------------

