#!/bin/bash
		
# wrapper-calc_bamstats.sh		
# This script starts an array job to drop low quality individuals from bcf files 
# The array job will start one job per bcf file
# Last updated 07/01/2024 by MI Clark, script format inspired by R Toczydlowski and T Linderoth

#  run from project directory (where you want output directory to be created)

# define high level vars
date=$(date +%m%d%Y)
jobname=drop_inds

# define dirs
indir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/rawBCF
outdir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/dropBCF
logfilesdir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/${jobname}

# define input and output files
bcflist=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/rawBCF_list.txt

# define running vars
cpus=1
total_mem=25G
array_no=$(ls $chrom_list_dir | wc -l) #***

# define executable, reference and needed scripts
executable=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/drop_inds_from_bcf.sbatch

#check if logfiles directory has been created in submit dir yet; if not, make one
if [ ! -d $logfilesdir ]; then mkdir $logfilesdir; fi
if [ ! -d $outdir ]; then mkdir $outdir; fi

sbatch --job-name=$jobname \
--array=1-50 \
--export=OUTDIR=$outdir,INDIR=$indir,CPUS=$cpus,BCFLIST=$bcflist,LOGFILESDIR=$logfilesdir,DATE=$date \
--cpus-per-task=$cpus \
--mem=$total_mem \
--output=$logfilesdir/${jobname}_%A-%a.out \
--error=$logfilesdir/${jobname}_%A-%a.err \
--time=48:00:00 \
--account=bradburd \
$executable

echo I submitted an array job to run bamstats on ${inbam}!
echo ----------------------------------------------------------------------------------------

