#!/bin/bash
		
# Last updated 04/24/2023 by MI Clark, script format by R Toczydlowski 

#  run from project directory (where you want output directory to be created)

# define high level vars
jobname=gen_masks
perl_script=$HOME/EMR_WGS/scripts/bedmask.pl
executable=$HOME/EMR_WGS/scripts/gen_masks.sbatch

# define input and output files
bamstats=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/EMR_all_qc.bamstats
outprefix=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/EMR_mask
report=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/EMR_mask_report.txt

# define log file directory
date=$(date +%m%d%Y)
logfilesdir=$HOME/EMR_WGS/log_gen_mask_${date}

# define running vars
cpus=1
ram_per_cpu=24G


#check if logfiles directory has been created in submit dir yet; if not, make one
if [ ! -d $logfilesdir ]; then mkdir $logfilesdir; fi

sbatch --job-name=$jobname \
--export=EXEC=$perl_script,BAMSTATS=$bamstats,OUTPREFIX=$outprefix,REPORT=$report,CPUS=$cpus,RUN_NAME=$run_name,LOGFILESDIR=$logfilesdir,DATE=$date \
--cpus-per-task=$cpus \
--mem-per-cpu=$ram_per_cpu \
--output=$logfilesdir/${jobname}_%A.out \
--error=$logfilesdir/${jobname}_%A.err \
--time=24:00:00 \
$executable

echo I submitted to generate a bed mask!
echo ----------------------------------------------------------------------------------------


