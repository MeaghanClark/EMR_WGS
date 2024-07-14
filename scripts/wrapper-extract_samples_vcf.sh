#!/bin/bash
		
# wrapper-extract_samples.sh		
# This script starts an array job

# Last updated 07/14/2024 by MI Clark, script format inspired by R Toczydlowski 

#  run from project directory (where you want output directory to be created)

# define high level vars
jobname=isolate_MI
date=$(date +%m%d%Y)

#define dirs:
logfilesdir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/${jobname} 
chrom_list_dir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scaf_single_line

# define slurm job details
cpus=1
total_mem=12G
array_no=$(ls $chrom_list_dir | wc -l) #***

# define executable and reference files
executable=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/extract_samples_vcf.sbatch

#check if logfiles directory has been created in submit dir yet; if not, make one
if [ ! -d $logfilesdir ]; then mkdir $logfilesdir; fi

sbatch --job-name=$jobname \
		--array=4-$array_no \
		--export=CPUS=$cpus,RUN_NAME=$run_name \
		--cpus-per-task=$cpus \
		--mem=$total_mem \
		--output=$logfilesdir/${jobname}_${date}_%A-%a.out \
		--error=$logfilesdir/${jobname}_${date}_%A-%a.err \
		--time=168:00:00 \
		--account=bradburd \
		$executable

echo I submitted to normalize my bcf files!
echo ----------------------------------------------------------------------------------------

