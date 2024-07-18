#!/bin/bash
		
# wrapper-extract_all_variants.sh		
# This script starts an array job to annotate 
# The array job will start one job per BCF in bcflist
# Last updated 07/08/2024 by MI Clark, script format inspired by R Toczydlowski 

#  run from project directory (where you want output directory to be created)

# define high level vars
jobname=allsites_mask
date=$(date +%m%d%Y)

#define dirs:
logfilesdir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/${jobname} 
chrom_list_dir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scaf_single_line
indir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/annotate_vcf # not used
outdir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/ # not used

# define slurm job details
cpus=1
total_mem=20G
array_no=$(ls $chrom_list_dir | wc -l) #***

# define executable and reference files
executable=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/extract_all_variants.sbatch

#check if logfiles directory has been created in submit dir yet; if not, make one
if [ ! -d $logfilesdir ]; then mkdir $logfilesdir; fi
if [ ! -d $outdir ]; then mkdir $outdir; fi

sbatch --job-name=$jobname \
		--array=99-103 \
		--export=CPUS=$cpus,RUN_NAME=$run_name,CHROM_LIST_DIR=$chrom_list_dir,LOGFILESDIR=$logfilesdir,DATE=$date,INDIR=$indir,OUTDIR=$outdir \
		--cpus-per-task=$cpus \
		--mem=$total_mem \
		--output=$logfilesdir/${jobname}_${date}_%A-%a.out \
		--error=$logfilesdir/${jobname}_${date}_%A-%a.err \
		--time=168:00:00 \
		--account=bradburd \
		$executable

echo I submitted to normalize my bcf files!
echo ----------------------------------------------------------------------------------------

