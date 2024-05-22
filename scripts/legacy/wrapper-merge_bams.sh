#!/bin/bash
		
# Last updated 04/11/2023 by MI Clark, script format by R Toczydlowski 

#  run from project directory (where you want output directory to be created)


# define high level vars
jobname=bam_merge
executable=/$HOME/EMR_WGS/scripts/merge_bams.sbatch

# define input and output files
reference=/mnt/research/Fitz_Lab/ref/massasauga/EMR_ref_2021/Scatenatus_HiC_v1.1.fasta
bams=$HOME/EMR_WGS/bam_list_path.txt
outfile=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/mask/EMR_all_qc.bam

# define log file directory
date=$(date +%m%d%Y)
logfilesdir=$HOME/EMR_WGS/log_merge_${date}

# define running vars
cpus=4
ram_per_cpu=12


#check if logfiles directory hassbeen created in submit dir yet; if not, make one
if [ ! -d $logfilesdir ]; then mkdir $logfilesdir; fi

sbatch --job-name=$jobname \
--export=REFERENCE=$reference,CPUS=$cpus,RUN_NAME=$run_name,BAMS=$bams,OUTFILE=$outfile,LOGFILESDIR=$logfilesdir,DATE=$date \
--cpus-per-task=$cpus \
--mem-per-cpu=$ram_per_cpu \
--output=$logfilesdir/${jobname}_%A.out \
--error=$logfilesdir/${jobname}_%A.err \
--time=24:00:00 \
$executable

echo I submitted to merge all bams!
echo ----------------------------------------------------------------------------------------

