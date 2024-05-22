#!/bin/bash
		
# Last updated 04/21/2023 by MI Clark, script format by R Toczydlowski 

#  run from project directory (where you want output directory to be created)


# define high level vars
jobname=sum_bamstats
executable=/$HOME/EMR_WGS/scripts/sum_bamstats.sbatch

# define input and output files
statlist=$HOME/EMR_WGS/EMR_all_bamstats_list.txt 
outfile=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/EMR_all_qc.bamstats.summary
rscript=/$HOME/EMR_WGS/scripts/qualSummaryStats.R

# define log file directory
date=$(date +%m%d%Y)
logfilesdir=$HOME/EMR_WGS/log_sum_bamstats_${date}

# define running vars
cpus=1
ram_per_cpu=400G


#check if logfiles directory has been created in submit dir yet; if not, make one
if [ ! -d $logfilesdir ]; then mkdir $logfilesdir; fi

sbatch --job-name=$jobname \
--export=CPUS=$cpus,RUN_NAME=$run_name,RSCRIPT=$rscript,STATLIST=$statlist,OUTFILE=$outfile,LOGFILESDIR=$logfilesdir,DATE=$date \
--cpus-per-task=$cpus \
--mem-per-cpu=$ram_per_cpu \
--output=$logfilesdir/${jobname}_%A.out \
--error=$logfilesdir/${jobname}_%A.err \
--time=24:00:00 \
$executable

echo I submitted to summarize bamstats files!
echo ----------------------------------------------------------------------------------------


