#!/bin/bash

# load modules 
module purge
module load GCC/11.3.0  OpenMPI/4.1.4
module load SRA-Toolkit/3.0.3
module list


OUTDIR=/mnt/scratch/clarkm89/EMR_WGS_Mathur2023
ARRAY_KEY=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/Mathur2023_SRA_list.txt

while read SEQ_ID
do 
	
	fasterq-dump --outdir ${OUTDIR} --split-3 --bufsize=100000 --curcache 10000 --details ${SEQ_ID}
	
	wait
	
	echo downloaded data for ${SEQ_ID}
	
done < $ARRAY_KEY




