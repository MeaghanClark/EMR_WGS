#!/bin/bash
		
# wrapper-calc_bamstats.sh		
# This script starts an array job to run bamstats on merged bam file from merge_bams.sbatch
# The array job will start one job per chromosome grouping
# Last updated 07/04/2024 by MI Clark, script format inspired by R Toczydlowski and T Linderoth

#  run from project directory (where you want output directory to be created)

# define high level vars
date=$(date +%m%d%Y)
jobname=FST

# define dirs
logfilesdir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/${jobname}
outdir=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/Fst
popdir='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/pops'

# define running vars
cpus=1
total_mem=12G

# define executable, reference and needed scripts etc. 
executable=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/calc_pairwiseFst.sbatch
prefix='EMR_highQual_SNPs_nomaf_chrom_drop'

#check if logfiles directory has been created in submit dir yet; if not, make one
if [ ! -d $logfilesdir ]; then mkdir $logfilesdir; fi
if [ ! -d $outdir ]; then mkdir $outdir; fi


for i in {1..27}
do
  # Inner loop starts from i+1 to ensure unique pairs
  for j in $(seq $((i+1)) 27)
  do
    echo "$i $j"
    # define sites
	file1=$(ls -l ${popdir}/*.txt | sed -n "${i}p")
	file2=$(ls -l ${popdir}/*.txt | sed -n "${j}p")
	
	site1=$(echo $file1 | awk -F'/' '{print $NF}' | awk -F'.' '{print $1}')
	site2=$(echo $file2 | awk -F'/' '{print $NF}' | awk -F'.' '{print $1}')

    sbatch --job-name=$jobname \
		--array=1-$array_no \
		--export=I=$i,J=$j,CPUS=$cpus,LOGFILESDIR=$logfilesdir,DATE=$date,OUTDIR=$outdir,PREFIX=$prefix,POPDIR=$popdir,FILE1=$file1,FILE2=$file2,SITE1=$site1,SITE2=$site2 \
		--cpus-per-task=$cpus \
		--mem=$total_mem \
		--output=$logfilesdir/${jobname}_%A-%a.out \
		--error=$logfilesdir/${jobname}_%A-%a.err \
		--time=12:00:00 \
		--account=bradburd \
		$executable	
  done
done


echo I submitted an array job to run bamstats on ${inbam}!
echo ----------------------------------------------------------------------------------------
