#!/bin/bash
		
# wrapper-normalize_variants.sh		
# This script starts an array job normalize variants in raw bcf files
# The array job will start one job per BCF in bcflist
# Last updated 05/21/2024 by MI Clark, script format inspired by R Toczydlowski 

#  run from project directory (where you want output directory to be created)


# define high level vars
jobname=bcf_norm
date=$(date +%m%d%Y)

#define dirs:
logfilesdir=$HOME/EMR_WGS/log_norm_${date} # CHANGE
chrom_list_dir=/path/to/dir/with/files/specifying/chroms # ***need to make chrom files
indir=/path/to/bcf/files
outdir=/path/to/where/norm/bcf/files/go

# define slurm job details
cpus=4
ram_per_cpu=12
array_no=$(ls $chrom_list_dir | wc -l) #***

# define executable and reference files
reference=/mnt/research/Fitz_Lab/ref/massasauga/EMR_ref_2021/Scatenatus_HiC_v1.1.fasta
executable=./scripts/normalize_variants.sbatch

#check if logfiles directory has been created in submit dir yet; if not, make one
if [ ! -d $logfilesdir ]; then mkdir $logfilesdir; fi

sbatch --job-name=$jobname \
		--array=1-$array_no \
		--export=REFERENCE=$reference,CPUS=$cpus,RUN_NAME=$run_name,BCFLIST=$bcflist,LOGFILESDIR=$logfilesdir,DATE=$date,INDIR=$indir,OUTDIR=$outdir,CHROM_LIST_DIR=$chrom_list_dir \
		--cpus-per-task=$cpus \
		--mem-per-cpu=$ram_per_cpu \
		--output=$logfilesdir/${jobname}_%A.out \
		--error=$logfilesdir/${jobname}_%A.err \
		--time=24:00:00 \
		$executable

echo I submitted to normalize my bcf files!
echo ----------------------------------------------------------------------------------------

