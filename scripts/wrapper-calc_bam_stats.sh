#!/bin/bash
		
# Last updated 04/11/2023 by MI Clark, script format by R Toczydlowski 

#  run from project directory (where you want output directory to be created)

# define high level vars
jobname=bam_stats
executable=/$HOME/EMR_WGS/scripts/calc_bam_stats.sbatch

# define input and output files
reference=/mnt/research/Fitz_Lab/ref/massasauga/EMR_ref_2021/Scatenatus_HiC_v1.1.fasta
inbam=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/mask/EMR_all_qc.bam
bamstats=/mnt/research/Fitz_Lab/software/ngsQC/bamstats/bamstats

# define log file directory
date=$(date +%m%d%Y)
logfilesdir=$HOME/EMR_WGS/log_bamstats_${date}

# define running vars
cpus=1
ram_per_cpu=25G

#check if logfiles directory has been created in submit dir yet; if not, make one
if [ ! -d $logfilesdir ]; then mkdir $logfilesdir; fi

sbatch --job-name=$jobname \
--array=1-98 \
--export=REFERENCE=$reference,CPUS=$cpus,RUN_NAME=$run_name,BAMSTATS=$bamstats,INBAM=$inbam,LOGFILESDIR=$logfilesdir,DATE=$date \
--cpus-per-task=$cpus \
--mem-per-cpu=$ram_per_cpu \
--output=$logfilesdir/${jobname}_%A-%a.out \
--error=$logfilesdir/${jobname}_%A-%a.err \
--time=24:00:00 \
$executable

echo I submitted an array job to run bamstats on ${inbam}!
echo ----------------------------------------------------------------------------------------

