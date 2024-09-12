#!/bin/bash
		
# wrapper-gen_masks.sh		
# This script starts an array job to run gen_masks in an array job
# The array job will start one job per chromosome grouping
# Last updated 09/12/2024 by MI Clark, script format inspired by R Toczydlowski and T Linderoth

#  run from project directory (where you want output directory to be created)

# define high level vars
date=$(date +%m%d%Y)
jobname=gen_mask

# define dirs
chrom_list_dir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/chrom_200_r
logfilesdir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/${jobname}

# define running vars
cpus=1
total_mem=12G
array_no=$(ls $chrom_list_dir | wc -l) #***

# define executable, reference and needed scripts
executable=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/gen_masks.sbatch

#check if logfiles directory has been created in submit dir yet; if not, make one
if [ ! -d $logfilesdir ]; then mkdir $logfilesdir; fi
if [ ! -d $outdir ]; then mkdir $outdir; fi

sbatch --job-name=$jobname \
--array=1-$array_no \
--export=OUTDIR=$outdir,CPUS=$cpus,LOGFILESDIR=$logfilesdir,DATE=$date,CHROM_LIST_DIR=$chrom_list_dir \
--cpus-per-task=$cpus \
--mem=$total_mem \
--output=$logfilesdir/${jobname}_%A-%a.out \
--error=$logfilesdir/${jobname}_%A-%a.err \
--time=24:00:00 \
--account=bradburd \
$executable

echo I submitted an array job to split ${big_bamstats}!
echo ----------------------------------------------------------------------------------------

