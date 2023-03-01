#!/bin/bash
		
# Last updated 08/24/2020 by MI Clark, script format by R Toczydlowski 

#  run from project directory (where you want output directory to be created)

#define variables:
storagenode=/mnt/home/clarkm89 #path to top level of dir where input/output files live
scratchnode=/mnt/scratch/clarkm89/massasauga_call_snps

jobname=call_snps_21 #label for SLURM book-keeping 
logfilesdir=logfiles_call_snps_from_list #name of directory to create and then write log files to
executable=/mnt/home/clarkm89/massasauga/scripts/call_snps_from_list.sbatch #script to run 

cpus=1 #number of CPUs to request/use per dataset 
ram_per_cpu=4G #amount of RAM to request/use per CPU

run_name=massasauga #label to use on output files
reference=$storagenode/$run_name/reference/Scatenatus_HiC_v1.1.fasta  #filepath of reference file
list_of_bamfiles=$storagenode/$run_name/bam_list_path.txt #list with paths to bam files we want to call SNPs for

#---------------------------------------------------------

#check if logfiles directory has been created in submit dir yet; if not, make one
if [ ! -d ./$logfilesdir ]; then mkdir ./$logfilesdir; fi

		
#define path to where input sequence data live for this dataset
#and where clean/processed reads should be written to

indir=/mnt/scratch/clarkm89/massasauga_alignments_temp
outdir=$storagenode/$run_name/called_snps_21	
vcf_name=EMR_all_ind_100621
	
#if input directory doesn't contain at least 1 .bam file; print warning, otherwise proceed with files that are there
n_inputfiles=($(ls $indir/*.bam | wc -l))
if [ $n_inputfiles = 0 ]
	then echo WARNING - there are no .bam files in $indir, go investigate
else
# TESTING
echo I am exporting: $reference, $cpus, $run_name, $vcf_name, $list_of_bamfiles, $storagenode, $scratchnode, $indir, $outdir, $logfilesdir
echo My executable is $executable

#submit job to cluster

sbatch --job-name=$jobname \
--export=REFERENCE=$reference,CPUS=$cpus,RUN_NAME=$run_name,VCF_NAME=$vcf_name,LIST_OF_BAMFILES=$list_of_bamfiles,STORAGENODE=$storagenode,SCRATCHNODE=$scratchnode,INDIR=$indir,OUTDIR=$outdir,LOGFILESDIR=$logfilesdir \
--cpus-per-task=$cpus \
--mem-per-cpu=$ram_per_cpu \
--output=./$logfilesdir/${jobname}_${run_name}_${vcf_name}_%A.out \
--error=./$logfilesdir/${jobname}_${run_name}_${vcf_name}_%A.err \
--time=168:00:00 \
$executable
			
echo I submitted to call SNPs woohoo!
echo ----------------------------------------------------------------------------------------
fi		

