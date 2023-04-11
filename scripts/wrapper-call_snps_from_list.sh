#!/bin/bash
		
# Last updated 03/01/2023 by MI Clark, script format by R Toczydlowski 

#  run from project directory (where you want output directory to be created)

# define upper variables
date=$(date +%m%d%Y)
jobname=call_snps #label for SLURM book-keeping 
executable=./scripts/call_snps_from_list.sbatch #script to run 
run_name=EMR_WGS #label to use on output files

#define dirs:
homedir=/mnt/home/clarkm89
storagenode=/mnt/research/Fitz_Lab/projects/massasauga # Path to top level of dir where where alignments files are stored
scratchnode=/mnt/scratch/clarkm89/massasauga_call_snps # path to scratch dir where temp files will be stored
logfilesdir=log_call_snps_${date} #name of directory to create and then write log files to
indir=$storagenode/EMR_WGS_alignments_02282023
outdir=$homedir/$run_name/called_snps


cpus=1 #number of CPUs to request/use per dataset 
ram_per_cpu=2G #amount of RAM to request/use per CPU

reference=$homedir/$run_name/reference/Scatenatus_HiC_v1.1.fasta  #filepath of reference file
list_of_bamfiles=$homedir/$run_name/bam_list_path.txt #list with paths to bam files we want to call SNPs for
vcf_name=EMR_WGS_${date}

#---------------------------------------------------------
	
#check if logfiles directory has been created in submit dir yet; if not, make one
if [ ! -d ./$logfilesdir ]; then mkdir ./$logfilesdir; fi

#check if scratch node storage directory has been created yet; if not, make one
if [ ! -d $scratchnode ]; then mkdir $scratchnode; fi

#check if outdir  has been created yet; if not, make one
if [ ! -d $outdir ]; then mkdir $outdir; fi

#if input directory doesn't contain at least 1 .bam file; print warning, otherwise proceed with files that are there
n_inputfiles=($(ls $indir/*.bam | wc -l))
if [ $n_inputfiles = 0 ]
	then echo WARNING - there are no .bam files in $indir, go investigate
else
	echo I am exporting: $reference, $cpus, $run_name, $vcf_name, $list_of_bamfiles, $storagenode, $scratchnode, $indir, $outdir, $logfilesdir
	echo My executable is $executable

#submit job to cluster

	sbatch --job-name=$jobname \
	--export=REFERENCE=$reference,CPUS=$cpus,RUN_NAME=$run_name,VCF_NAME=$vcf_name,LIST_OF_BAMFILES=$list_of_bamfiles,STORAGENODE=$storagenode,SCRATCHNODE=$scratchnode,INDIR=$indir,OUTDIR=$outdir,LOGFILESDIR=$logfilesdir \
	--cpus-per-task=$cpus \
	--mem-per-cpu=$ram_per_cpu \
	--output=./$logfilesdir/${jobname}_${vcf_name}_%A.out \
	--error=./$logfilesdir/${jobname}_${vcf_name}_%A.err \
	--time=72:00:00 \
	$executable
			
echo I submitted to call SNPs woohoo!
echo ----------------------------------------------------------------------------------------
fi		

