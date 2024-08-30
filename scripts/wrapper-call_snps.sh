#!/bin/bash
		
# wrapper-call_snps.sh		
# This script starts an array job to call SNPs on different chromosomes specified by files in "chrom_list_dir"
# Last updated 08/29/2024 by MI Clark, originally written by R Toczydlowski 

#  run from project directory (where you want output directory to be created)

# define high level variables
date=$(date +%m%d%Y)
jobname=call_snps #label for SLURM book-keeping 

#define dirs:
logfilesdir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/${jobname}
indir=/mnt/scratch/clarkm89/EMR_WGS/alignments/final
outdir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants
chrom_list_dir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/chrom_200

#check if directories have been created; if not, make 
if [ ! -d $logfilesdir ]; then mkdir $logfilesdir; fi
if [ ! -d $outdir ]; then mkdir $outdir; fi

# define slurm job details
cpus=1 #number of CPUs to request/use per dataset 
ram_per_cpu=24G #amount of RAM to request/use per CPU
array_no=$(ls $chrom_list_dir | wc -l) #***

# define executable and reference genome 
executable=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/call_snps.sbatch #script to run 
reference=/mnt/scratch/clarkm89/EMR_ref_2024/GCA_039880765.1/GCA_039880765.1_rSisCat1_p1.0_genomic.fna #filepath of reference file

list_of_bamfiles=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/final_bam_list.txt #list with paths to bam files we want to call SNPs for
sample_names=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/final_bam_sample_names.txt
ploidyf=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/mt_ploidy.txt ### indicates haploid mito. genome

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
		--export=REFERENCE=$reference,CPUS=$cpus,LIST_OF_BAMFILES=$list_of_bamfiles,OUTDIR=$outdir,LOGFILESDIR=$logfilesdir,PLOIDYF=$ploidyf,SAMPLE_NAMES=$sample_names,CHROM_LIST_DIR=$chrom_list_dir \
		--cpus-per-task=$cpus \
		--mem-per-cpu=$ram_per_cpu \
		--output=$logfilesdir/${jobname}_${date}_%A-%a.out \
		--error=$logfilesdir/${jobname}_${date}_%A-%a.err \
		--time=72:00:00 \
		--account=bradburd \
		$executable
			
echo I submitted to call SNPs woohoo!
echo ----------------------------------------------------------------------------------------

