#!/bin/bash
		
# Last updated 08/26/2023 by MI Clark, script format by R Toczydlowski 

#  run from project directory (where you want output directory to be created)

# define high level vars
jobname=bam_merge

# define dirs


#check if directories have been created; if not, make 
if [ ! -d $logfilesdir ]; then mkdir $logfilesdir; fi
if [ ! -d $outdir ]; then mkdir $outdir; fi
if [ ! -d $scratchnode ]; then mkdir $scratchnode; fi

# define slurm job details

# define input and output files
bams=$HOME/EMR_WGS/bam_list_path.txt
outfile=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/mask/EMR_all_qc.bam

# define log file directory
date=$(date +%m%d%Y)
logfilesdir=$HOME/EMR_WGS/log_merge_${date}

# define running vars
cpus=4
ram_per_cpu=12

# define executable and reference
executable=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/merge_bams.sbatch
reference=/mnt/scratch/clarkm89/EMR_ref_2024/GCA_039880765.1/GCA_039880765.1_rSisCat1_p1.0_genomic.fna #filepath of reference file

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

