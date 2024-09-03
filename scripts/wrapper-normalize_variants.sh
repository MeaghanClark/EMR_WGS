#!/bin/bash
		
# wrapper-normalize_variants.sh		
# This script starts an array job normalize variants in raw bcf files
# The array job will start one job per BCF in bcflist
# Last updated 09/03/2024 by MI Clark, script format inspired by R Toczydlowski 

#  run from project directory (where you want output directory to be created)


# define high level vars
jobname=bcf_norm
date=$(date +%m%d%Y)

#define dirs:
logfilesdir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/${jobname} 
chrom_list_dir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/scaffolds # make scaffolds dir and list --> 
indir=/mnt/scratch/clarkm89/EMR_WGS/variants/
outdir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/norm_byScaf

#check if directories have been created yet; if not, make one
if [ ! -d $logfilesdir ]; then mkdir $logfilesdir; fi
if [ ! -d $outdir ]; then mkdir $outdir; fi

# define slurm job details
cpus=6
total_mem=50G
array_no=$(ls $chrom_list_dir | wc -l) 

# define executable and reference files
reference=/mnt/scratch/clarkm89/EMR_ref_2024/GCA_039880765.1/GCA_039880765.1_rSisCat1_p1.0_genomic.fna #filepath of reference file
executable=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/normalize_variants.sbatch


sbatch --job-name=$jobname \
		--array=1-$array_no \
		--export=REFERENCE=$reference,CPUS=$cpus,CHROM_LIST_DIR=$chrom_list_dir,RUN_NAME=$run_name,LOGFILESDIR=$logfilesdir,DATE=$date,INDIR=$indir,OUTDIR=$outdir \
		--cpus-per-task=$cpus \
		--mem=$total_mem \
		--output=$logfilesdir/${jobname}_${date}_%A-%a.out \
		--error=$logfilesdir/${jobname}_${date}_%A-%a.err \
		--time=96:00:00 \
		--account=bradburd \
		$executable

echo I submitted to normalize my bcf files!
echo ----------------------------------------------------------------------------------------

