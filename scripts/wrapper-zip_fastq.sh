#!/bin/bash

# wrapper-zip_fastq.sh
# This script starts slurm jobs to zip fastq files in parallel
# Last updated 06/16/2024 by MI Clark, script format inspired by R Toczydlowski 

# define high level variables
jobname=zip
array_key=/mnt/scratch/clarkm89/EMR_WGS_Mathur2023/fastq_files.txt
rundate=$(date +%m%d%Y)

# define directories
outdir=/mnt/scratch/clarkm89/EMR_WGS_Mathur2023
logfilesdir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/zip_fastq
 
# make sure log dir exists
if [ ! -d $logfilesdir ]; then mkdir $logfilesdir; fi

# define slurm job details
cpus=1
ram_per_cpu=8G
array_no=$(cat $array_key | wc -l)

# define executable 
executable=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/zip_fastq.sbatch

sbatch --job-name=$jobname \
	--array=1-$array_no \
	--export=JOBNAME=$jobname,ARRAY_KEY=$array_key,OUTDIR=$outdir,CPUS=$cpus,RUNDATE=$rundate,EXECUTABLE=$executable,LOGFILESDIR=$logfilesdir \
	--cpus-per-task=$cpus \
	--mem-per-cpu=$ram_per_cpu \
	--output=$logfilesdir/${jobname}_${rundate}_%A-%a.out \
	--error=$logfilesdir/${jobname}_${rundate}_%A-%a.err \
	--time=12:00:00 \
	--account=bradburd \
	$executable

echo ----------------------------------------------------------------------------------------
echo My executable is $executable		
