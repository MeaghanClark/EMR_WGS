#!/bin/bash

# wrapper-align_to_genome.sh		
# This script starts an array job to align trimmed sequencing reads output by trim_reads.sbatch to a reference genome
# Last updated 06/03/2024 by MI Clark, originally written by R Toczydlowski 

# define high level variables
date=$(date +%m%d%Y)
jobname=align_to_genome #label for SLURM book-keeping 
array_key=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/trimmed_reads.txt # file with names of trimmed reads, one ind per line, reads separated by blank space

#define dirs:
indir=/mnt/scratch/clarkm89/EMR_WGS/processedReads/ # defined in array_key
outdir=/mnt/scratch/clarkm89/EMR_WGS/alignments/
scratchnode=/mnt/scratch/clarkm89/EMR_WGS/alignmentsTemp/ # path to scratch dir where temp files will be stored
logfilesdir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/logs_${jobname} #name of directory to create and then write log files to

#if input directory doesn't contain at least 1 .gz file; print warning, otherwise proceed with files that are there
n_inputfiles=($(ls $indir/*.gz | wc -l))
if [ $n_inputfiles = 0 ]
	then echo WARNING - there are no .gz files in $indir, go investigate
fi

#check if directories have been created; if not, make 
if [ ! -d $logfilesdir ]; then mkdir $logfilesdir; fi
if [ ! -d $outdir ]; then mkdir $outdir; fi
if [ ! -d $scratchnode ]; then mkdir $scratchnode; fi


# define slurm job details
cpus=6 #number of CPUs to request/use per dataset
ram_per_cpu=8G #amount of RAM to request/use per CPU CHANGE
array_no=$(cat $array_key | wc -l)

# define executable and reference genome 
executable=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/align_to_genome.sbatch #script to run 
reference=/mnt/research/Fitz_Lab/ref/massasauga/EMR_ref_2021/Scatenatus_HiC_v1.1.fasta #filepath of reference file

#---------------------------------------------------------
# required exports to executable: 
#	ARRAY_KEY
# 	REFERENCE
# 	CPUS
#	OUTDIR
#	INDIR
#	SCRATCHNODE

#submit job to cluster
sbatch --job-name=$jobname \
		--array=1-$array_no \
		--export=ARRAY_KEY=$array_key,REFERENCE=$reference,CPUS=$cpus,SCRATCHNODE=$scratchnode,INDIR=$indir,OUTDIR=$outdir,LOGFILESDIR=$logfilesdir \
		--cpus-per-task=$cpus \
		--mem-per-cpu=$ram_per_cpu \
		--output=$logfilesdir/${jobname}_${date}_%A-%a.out \
		--error=$logfilesdir/${jobname}_${date}_%A-%a.err \
		--time=72:00:00 \
		$executable
		
echo submitted a job to align reads in $indir to $reference

echo ----------------------------------------------------------------------------------------
echo My executable is $executable		
