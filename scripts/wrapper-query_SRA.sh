#!/bin/bash

# wrapper-query_SRA.sh
# This script starts slurm jobs to download a list of files from the SRA database
# Last updated 06/13/2024 by MI Clark, script format inspired by R Toczydlowski 

# define high level variables
jobname=query_SRA
array_key=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/Mathur2023_SRA_list.txt
rundate=$(date +%m%d%Y)

# define directories
outdir=/mnt/scratch/clarkm89/EMR_WGS_Mathur2023
logfilesdir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/query_SRA
 
# make sure log dir exists
if [ ! -d $logfilesdir ]; then mkdir $logfilesdir; fi

# define slurm job details
cpus=4
ram_per_cpu=12G
array_no=$(cat $array_key | wc -l)

# define executable 
executable=/mnt/research/Fitz_Lab/projects/massasauga/WGS/scripts/query_SRA.sbatch

sbatch --job-name=$jobname \
	--array=1-$array_no \
	--export=JOBNAME=$jobname,ARRAY_KEY=$array_key,CPUS=$cpus,RUNDATE=$rundate,EXECUTABLE=$executable,LOGFILESDIR=$logfilesdir \
	--cpus-per-task=$cpus \
	--mem-per-cpu=$ram_per_cpu \
	--output=$logfilesdir/${jobname}_${rundate}_%A-%a.out \
	--error=$logfilesdir/${jobname}_${rundate}_%A-%a.err \
	--time=24:00:00 \
	--account=bradburd \
	$executable

echo ----------------------------------------------------------------------------------------
echo My executable is $executable		
