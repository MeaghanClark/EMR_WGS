#!/bin/bash
		
# Last updated 04/11/2023 by MI Clark, script format by R Toczydlowski 

#  run from project directory (where you want output directory to be created)


# define high level vars
jobname=bcf_norm
executable=/$HOME/EMR_WGS/scripts/normalize_variants.sbatch

# define input and output files
reference='/mnt/research/Fitz_Lab/ref/massasauga/EMR_ref_2021/Scatenatus_HiC_v1.1.fasta'
inbcf='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/raw_calls/EMR_WGS_03222023.bcf.gz'
outbcf='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/raw_calls/EMR_WGS_03222023_norm.bcf.gz'

# define log file directory
date=$(date +%m%d%Y)
logfilesdir=$HOME/EMR_WGS/log_norm_${date}

# define running vars
cpus=4
ram_per_cpu=12


#check if logfiles directory has been created in submit dir yet; if not, make one
if [ ! -d $logfilesdir ]; then mkdir $logfilesdir; fi

sbatch --job-name=$jobname \
--export=REFERENCE=$reference,CPUS=$cpus,RUN_NAME=$run_name,INBCF=$inbcf,OUTBCF=$outbcf,LOGFILESDIR=$logfilesdir,DATE=$date \
--cpus-per-task=$cpus \
--mem-per-cpu=$ram_per_cpu \
--output=$logfilesdir/${jobname}_%A.out \
--error=$logfilesdir/${jobname}_%A.err \
--time=24:00:00 \
$executable

echo I submitted to normalize my bcf file!
echo ----------------------------------------------------------------------------------------

