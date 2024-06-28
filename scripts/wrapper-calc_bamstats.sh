#!/bin/bash
		
# wrapper-calc_bamstats.sh		
# This script starts an array job to run bamstats on merged bam file from merge_bams.sbatch
# The array job will start one job per chromosome grouping
# Last updated 06/24/2024 by MI Clark, script format inspired by R Toczydlowski and T Linderoth

#  run from project directory (where you want output directory to be created)

# define high level vars
date=$(date +%m%d%Y)
jobname=bamstats

# define dirs
chrom_list_dir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/chrom_200
logfilesdir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/${jobname}
outdir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats

# define input and output files
inbam=/mnt/scratch/clarkm89/EMR_WGS/bamstats/mega_bam.bam

# define running vars
cpus=1
ram_per_cpu=25G
array_no=$(ls $chrom_list_dir | wc -l) #***

# define executable, reference and needed scripts
reference=/mnt/research/Fitz_Lab/ref/massasauga/EMR_ref_2021/Scatenatus_HiC_v1.1.fasta
executable=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/calc_bamstats.sbatch
bamstats=/mnt/research/Fitz_Lab/software/ngsQC/bamstats/bamstats

#check if logfiles directory has been created in submit dir yet; if not, make one
if [ ! -d $logfilesdir ]; then mkdir $logfilesdir; fi
if [ ! -d $outdir ]; then mkdir $outdir; fi

sbatch --job-name=$jobname \
--array=1-$array_no \
--export=REFERENCE=$reference,OUTDIR=$outdir,CPUS=$cpus,BAMSTATS=$bamstats,INBAM=$inbam,LOGFILESDIR=$logfilesdir,DATE=$date,CHROM_LIST_DIR=$chrom_list_dir \
--cpus-per-task=$cpus \
--mem-per-cpu=$ram_per_cpu \
--output=$logfilesdir/${jobname}_%A-%a.out \
--error=$logfilesdir/${jobname}_%A-%a.err \
--time=48:00:00 \
--account=bradburd \
$executable

echo I submitted an array job to run bamstats on ${inbam}!
echo ----------------------------------------------------------------------------------------

