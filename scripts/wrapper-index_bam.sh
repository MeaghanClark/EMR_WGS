#!/bin/bash
		
# wrapper-call_snps.sh		
# This script starts an array job to call SNPs on different chromosomes specified by files in "chrom_list_dir"
# Last updated 08/30/2024 by MI Clark, originally written by R Toczydlowski 

#  run from project directory (where you want output directory to be created)

# define high level variables
date=$(date +%m%d%Y)
jobname=index_bams #label for SLURM book-keeping 

#define dirs:
logfilesdir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/${jobname}
indir=/mnt/scratch/clarkm89/EMR_WGS/alignments/bam_flt_rerun
outdir=/mnt/scratch/clarkm89/EMR_WGS/alignments/bam_flt_rerun

#check if directories have been created; if not, make 
if [ ! -d $logfilesdir ]; then mkdir $logfilesdir; fi

# define slurm job details
cpus=1 #number of CPUs to request/use per dataset 
ram_per_cpu=24G #amount of RAM to request/use per CPU
array_no=$(ls $indir/*.bam | wc -l) #***

# define executable and reference genome 
executable=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/index_bam.sbatch #script to run 

find "$indir" -name "*.bam" > /mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/bams_to_index.txt 
list_of_bamfiles=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/bams_to_index.txt  #list with paths to bam files we want to call SNPs for

#---------------------------------------------------------

# Required explore variables to sbatch
#	(1) reference
#	(2) list of bamfiles
#	(3) OUTDIR
#	(4) CHROM_LIST_DIR
#	(5) SAMPLE_NAMES
#	(6) PLOIDY FILE

#submit job to cluster

sbatch --job-name=$jobname \
		--array=1-$array_no \
		--export=CPUS=$cpus,LIST_OF_BAMFILES=$list_of_bamfiles,OUTDIR=$outdir,INDIR=$indir,LOGFILESDIR=$logfilesdir \
		--cpus-per-task=$cpus \
		--mem-per-cpu=$ram_per_cpu \
		--output=$logfilesdir/${jobname}_${date}_%A-%a.out \
		--error=$logfilesdir/${jobname}_${date}_%A-%a.err \
		--time=72:00:00 \
		--account=bradburd \
		$executable
			
echo I submitted to call SNPs woohoo!
echo ----------------------------------------------------------------------------------------

