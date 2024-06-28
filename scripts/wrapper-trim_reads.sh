#!/bin/bash

# wrapper-trim_reads.sh
# This script starts an array job to run raw sequencing reads through fastp to trim adapters and polyG tails
# Last updated 06/17/2024 by MI Clark, script format inspired by R Toczydlowski 

# Required export to executable: 
#	(1) array_key = .txt file with full paths to raw sequencing files to run through fastp
#	(2) outdir = the path to the output directory 

# define high level variables
jobname=trim_reads
array_key=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/rawData_FRcols_Ster.txt # list of raw data with forward and reverse reads for the same individual on the same line
rundate=$(date +%m%d%Y)

# define directories
outdir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/processedReads/  # outdir on scratch because of storage limits
logfilesdir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/trimReads
 
# make sure dir exists
if [ ! -d $logfilesdir ]; then mkdir $logfilesdir; fi
if [ ! -d $outdir ]; then mkdir $outdir; fi


# define slurm job details
cpus=1
ram_per_cpu=24G
array_no=$(cat $array_key | wc -l)

# define executable 
executable=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/trim_reads.sbatch

sbatch --job-name=$jobname \
	--array=1-$array_no \
	--export=JOBNAME=$jobname,ARRAY_KEY=$array_key,CPUS=$cpus,RUNDATE=$rundate,EXECUTABLE=$executable,LOGFILESDIR=$logfilesdir,OUTDIR=$outdir \
	--cpus-per-task=$cpus \
	--mem-per-cpu=$ram_per_cpu \
	--output=$logfilesdir/${jobname}_${rundate}_%A-%a.out \
	--error=$logfilesdir/${jobname}_${rundate}_%A-%a.err \
	--time=4:00:00 \
	--account=bradburd \
	$executable

echo ----------------------------------------------------------------------------------------
echo My executable is $executable		


