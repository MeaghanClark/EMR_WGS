#!/bin/bash
		
# wrapper-split_bamstats_longjobs.sh		
# This script starts an array job to split a bamstats file into sections 
# The array job will start one job per chromosome grouping
# Last updated 06/24/2024 by MI Clark, script format inspired by R Toczydlowski and T Linderoth

#  run from project directory (where you want output directory to be created)

# define high level vars
date=$(date +%m%d%Y)
jobname=split_bamstats_long

# define dirs
chrom_list_dir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/chrom_200
logfilesdir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/${jobname}

# define input and output files
big_bamstats=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_ALL_qc_ordered.bamstats

# define running vars
cpus=1
total_mem=8G

# define executable, reference and needed scripts
executable=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/split_bamstats_longjobs.sbatch

#check if logfiles directory has been created in submit dir yet; if not, make one
if [ ! -d $logfilesdir ]; then mkdir $logfilesdir; fi

for i in 197 198 199 200; 
do
chrom_file=${chrom_list_dir}/chrom_list_${i}.txt
array_no=$(cat $chrom_file | wc -l)
outdir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/chrom_bamstats/chrom_${i}
if [ ! -d $outdir ]; then mkdir $outdir; fi

sbatch --job-name=$jobname \
--array=1-$array_no \
--export=OUTDIR=$outdir,CPUS=$cpus,I=$i,BIG_BAMSTATS=$big_bamstats,LOGFILESDIR=$logfilesdir,CHROM_FILE=$chrom_file,CHROM_LIST_DIR=$chrom_list_dir \
--cpus-per-task=$cpus \
--mem=$total_mem \
--output=$logfilesdir/${jobname}_${i}_%A-%a.out \
--error=$logfilesdir/${jobname}_${i}_%A-%a.err \
--time=12:00:00 \
--account=bradburd \
$executable

echo submitted job to subset $big_bamstats using $chrom_file
done


echo I submitted an array job to split ${big_bamstats}!
echo ----------------------------------------------------------------------------------------

