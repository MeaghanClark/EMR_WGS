#!/bin/bash

# wrapper-trim_reads.sh
# This script starts an array job to run raw sequencing reads through fastp to trim adapters and polyG tails
# Last updated 05/16/2024 by MI Clark, script format inspired by R Toczydlowski 

# Required export to executable: 
#	(1) array_key = .txt file with full paths to raw sequencing files to run through fastp
#	(2) outdir = the path to the output directory 

# define high level variables
jobname=trim_reads
array_key=/mnt/research/Fitz_Lab/projects/massasauga/WGS/scripts/keys/rawData_list.txt # make rawData_list.txt
rundate=$(date +%m%d%Y)

# define directories
indir=/mnt/research/Fitz_Lab/projects/massasauga/WGS/rawData/
outdir=/mnt/research/Fitz_Lab/projects/massasauga/WGS/processedReads/
logfilesdir=/mnt/research/Fitz_Lab/projects/massasauga/WGS/logs/
 
# define slurm job details
cpus=1
ram_per_cpu=24G
array_no=$(cat $array_key | wc -l)

# define executable 
executable=/path/to/run_fastQC.sbatch # CHANGE

sbatch --job-name=$jobname \
	--array=1-$array_no \
	--export=JOBNAME=$jobname,ARRAY_KEY=$array_key,CPUS=$cpus,RUNDATE=$rundate,EXECUTABLE=$executable,LOGFILESDIR=$logfilesdir,OUTDIR=$outdir,INDIR=$indir \
	--cpus-per-task=$cpus \
	--mem-per-cpu=$ram_per_cpu \
	--output=$logfilesdir/${jobname}_${rundate}_%A-%a.out \
	--error=$logfilesdir/${jobname}_${rundate}_%A-%a.err \
	--time=24:00:00 \
	$executable

echo ----------------------------------------------------------------------------------------
echo My executable is $executable		

