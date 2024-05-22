#!/bin/bash
		
# wrapper-call_snps.sh		
# This script starts an array job to call SNPs on different chromosomes specified by files in "chrom_list_dir"
# Last updated 05/17/2024 by MI Clark, originally written by R Toczydlowski 

#  run from project directory (where you want output directory to be created)

# define high level variables
date=$(date +%m%d%Y)
jobname=call_snps #label for SLURM book-keeping 

#define dirs:
homedir=/mnt/home/clarkm89
logfilesdir=log_call_snps_${date} # CHANGE 
indir=/path/EMR_WGS_alignments_02282023 # CHANGE
outdir=/path/called_snps # CHANGE
chrom_list_dir=/path/to/dir/with/files/specifying/chroms # ***need to make chrom files

# define slurm job details
cpus=1 #number of CPUs to request/use per dataset 
ram_per_cpu=2G #amount of RAM to request/use per CPU
array_no=$(ls $chrom_list_dir | wc -l) #***

# define executable and reference genome 
executable=./scripts/call_snps.sbatch #script to run 
reference=$homedir/$run_name/reference/Scatenatus_HiC_v1.1.fasta #filepath of reference file
list_of_bamfiles=$homedir/$run_name/bam_list_path.txt #list with paths to bam files we want to call SNPs for


#---------------------------------------------------------
	
#check if logfiles directory has been created in submit dir yet; if not, make one
if [ ! -d $logfilesdir ]; then mkdir $logfilesdir; fi

#check if outdir  has been created yet; if not, make one
if [ ! -d $outdir ]; then mkdir $outdir; fi

# Required explore variables to sbatch
#	(1) reference
#	(2) list of bamfiles
#	(3) OUTDIR
#	(4) CHROM_LIST_DIR

#submit job to cluster

sbatch --job-name=$jobname \
		--array=1-$array_no \
		--export=REFERENCE=$reference,CPUS=$cpus,LIST_OF_BAMFILES=$list_of_bamfiles,OUTDIR=$outdir,LOGFILESDIR=$logfilesdir,CHROM_LIST_DIR=$chrom_list_dir \
		--cpus-per-task=$cpus \
		--mem-per-cpu=$ram_per_cpu \
		--output=./$logfilesdir/${jobname}_%A_%a.out \
		--error=./$logfilesdir/${jobname}_%A_%a.err \
		--time=72:00:00 \
		$executable
			
echo I submitted to call SNPs woohoo!
echo ----------------------------------------------------------------------------------------
fi		

