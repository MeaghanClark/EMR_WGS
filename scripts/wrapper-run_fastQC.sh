#!/bin/bash

# wrapper-runfastQC.sh
# This script starts slurm jobs to runs fastQC on raw sequencing reads in parallel 
# Last updated 06/03/2024 by MI Clark, script format inspired by R Toczydlowski 

# Required export to executable: 
#	(1) array_key = .txt file with full paths to raw sequencing file to run through fastQC, one per line
#	(2) outdir = the path to the output directory 


# define high level variables
jobname=run_fastQC
array_key=/mnt/research/Fitz_Lab/projects/massasauga/WGS/scripts/keys/rawData_list.txt # make rawData_list.txt
rundate=$(date +%m%d%Y)

# define directories
outdir=/mnt/research/Fitz_Lab/projects/massasauga/WGS/rawReadsQC # CHANGE
logfilesdir=/mnt/research/Fitz_Lab/projects/massasauga/WGS/logs # CHANGE
 
# define slurm job details
cpus=1
ram_per_cpu=24G
array_no=$(cat $array_key | wc -l)

# define executable 
executable=/mnt/research/Fitz_Lab/projects/massasauga/WGS/scripts/run_fastQC.sbatch # CHANGE


sbatch --job-name=$jobname \
	--array=1-$array_no \
	--export=JOBNAME=$jobname,ARRAY_KEY=$array_key,CPUS=$cpus,RUNDATE=$rundate,EXECUTABLE=$executable,LOGFILESDIR=$logfilesdir \
	--cpus-per-task=$cpus \
	--mem-per-cpu=$ram_per_cpu \
	--output=$logfilesdir/${jobname}_${rundate}_%A-%a.out \
	--error=$logfilesdir/${jobname}_${rundate}_%A-%a.err \
	--time=24:00:00 \
	$executable

echo ----------------------------------------------------------------------------------------
echo My executable is $executable		
