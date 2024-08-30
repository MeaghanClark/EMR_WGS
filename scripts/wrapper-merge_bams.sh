#!/bin/bash
		
# Last updated 08/26/2023 by MI Clark, script format by R Toczydlowski 

#  run from project directory (where you want output directory to be created)

# define high level vars
jobname=bam_merge
date=$(date +%m%d%Y)
array_key=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/bams_to_merge.txt # file with file paths to bams to merge, one ind per line, reads separated by blank space


# define dirs
outdir=/mnt/scratch/clarkm89/EMR_WGS/alignments/${jobname}
logfilesdir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/${jobname} #name of directory to create and then write log files to

#check if directories have been created; if not, make 
if [ ! -d $logfilesdir ]; then mkdir $logfilesdir; fi
if [ ! -d $outdir ]; then mkdir $outdir; fi
if [ ! -d $scratchnode ]; then mkdir $scratchnode; fi

# define running vars
cpus=4
mem=12G
array_no=$(cat $array_key | wc -l)

# define executable and reference
executable=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/merge_bams.sbatch
reference=/mnt/scratch/clarkm89/EMR_ref_2024/GCA_039880765.1/GCA_039880765.1_rSisCat1_p1.0_genomic.fna #filepath of reference file


sbatch --job-name=$jobname \
		--array=1-$array_no \
		--export=ARRAY_KEY=$array_key,REF=$reference,CPUS=$cpus,OUTDIR=$outdir,LOGFILESDIR=$logfilesdir \
		--cpus-per-task=$cpus \
		--mem=$mem \
		--output=$logfilesdir/${jobname}_${date}_%A-%a.out \
		--error=$logfilesdir/${jobname}_${date}_%A-%a.err \
		--time=4:00:00 \
		--account=bradburd \
		$executable


echo I submitted to merge all bams!
echo ----------------------------------------------------------------------------------------

