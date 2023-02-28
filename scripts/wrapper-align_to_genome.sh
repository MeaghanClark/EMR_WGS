#!/bin/bash
		
# Last updated 04/16/2020 by MI Clark, originally written by R Toczydlowski 

# this version of the script is written if you have multiple sequencing lanes for the same individual. If you use the other script, 
# you will overwrite output files due to naming scheme. This script produces files with more annoying names, 
# but will not overwrite files. 
#

#  run from project directory (where you want output directory to be created)

#define variables:
storagenode=/mnt/home/clarkm89 #path to top level of dir where input/output files live
scratchnode=/mnt/scratch/clarkm89/massasauga_alignments_temp

jobname=run-align_21 #label for SLURM book-keeping 
logfilesdir=logfiles_aligntogenome #name of directory to create and then write log files to
executable=./scripts/align_to_genome.sbatch #script to run 

cpus=6 #number of CPUs to request/use per dataset
ram_per_cpu=2G #amount of RAM to request/use per CPU CHANGE

list_of_seqfiles=align_input.txt #list with names of seq files we want to align 
run_name=massasauga #label to use on output files
reference=$storagenode/$run_name/reference/Scatenatus_HiC_v1.1.fasta #filepath of reference file

#---------------------------------------------------------

#check if logfiles directory has been created in submit dir yet; if not, make one
if [ ! -d ./$logfilesdir ]; then mkdir ./$logfilesdir; fi

#for each line of the list_of_seqfiles file: 
#	execute job that XXXXXX (whatever it does)  
while read seqfiles
do 
	
	#split up seqfile line into forward and reverse variables
	forwardread=$(echo $seqfiles | cut -d " " -f 1)
	reverseread=$(echo $seqfiles | cut -d " " -f 2)
	ind_name=$(echo $forwardread | cut -d "_" -f 1,2)
	sample_name=$(echo $forwardread | cut -d "_" -f 1,2,5)
	
	#define path to where input sequence data live for this dataset
	#and where clean/processed reads should be written to
	indir=$storagenode/$run_name/Rawdata/$ind_name
	outdir=$storagenode/$run_name/alignments
	
	#if input directory doesn't contain at least 1 .gz file; print warning, otherwise proceed with files that are there
	n_inputfiles=($(ls $indir/*.gz | wc -l))
	if [ $n_inputfiles = 0 ]
		then echo WARNING - there are no .gz files in $indir, go investigate
	else

	#submit job to cluster
	sbatch --job-name=$jobname \
			--export=REFERENCE=$reference,FORWARDREAD=$forwardread,REVERSEREAD=$reverseread,CPUS=$cpus,RUN_NAME=$run_name,SAMPLE_NAME=$sample_name,STORAGENODE=$storagenode,SCRATCHNODE=$scratchnode,INDIR=$indir,OUTDIR=$outdir,LOGFILESDIR=$logfilesdir \
			--cpus-per-task=$cpus \
			--mem-per-cpu=$ram_per_cpu \
			--output=./$logfilesdir/${jobname}_${run_name}_${sample_name}_%A.out \
			--error=./$logfilesdir/${jobname}_${run_name}_${sample_name}_%A.err \
			--time=22:00:00 \
			$executable
			
	echo submitted a job to align forward read $forwardread and reverse read $reverseread from individual $sample_name to $reference
	fi		
done < $list_of_seqfiles

