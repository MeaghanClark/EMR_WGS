#!/bin/bash

#--------------- EXECUTABLE ---------------

# This script aligns pairs of forward and reverse sequence files listed in a text file to the given reference
# Last updated 02/28/2023 by MI Clark, originally written by MI Clark and R Toczydlowski based on script by B Reid
# Input: Reference genome path, forward and reverse reads from wrapper-align_to_genome.sh 
#
# Output: ${SAMPLE_NAME}.rmdup.bam file, forward and reverse reads aligned to reference genome
#			final .bam files are stored in directory at <storagenode>/<run_name>/alignments 
#			example: /mnt/home/clarkm89/massasauga/alignments/PCC_321.rmdup.bam 

#load programs we want to use
module purge
module load GCC/6.4.0-2.28
module load OpenMPI/2.1.1
module load SAMtools
module load BWA/0.7.17
module load powertools
module list 
 
# text for troubleshooting
echo using $REFERENCE 
echo trying to locate files ${INDIR}/$FORWARDREAD and ${INDIR}/$REVERSEREAD
echo I will put the output in ${SCRATCHNODE}/${SAMPLE_NAME}.aln-pe.sam 

#run bwa 
bwa mem -t $CPUS $REFERENCE ${INDIR}/$FORWARDREAD ${INDIR}/$REVERSEREAD > ${SCRATCHNODE}/${SAMPLE_NAME}.aln-pe.sam 
 
echo I have created a .sam file for $SAMPLE_NAME and put it in $SCRATCHNODE

 # run samtools
samtools view -Sb -o ${SCRATCHNODE}/${SAMPLE_NAME}.aln-pe.bam ${SCRATCHNODE}/${SAMPLE_NAME}.aln-pe.sam #change sam to bam
echo I have converted the .sam file to a .bam file and saved it in ${SCRATCHNODE}

samtools sort -n -o ${SCRATCHNODE}/${SAMPLE_NAME}.sort.bam ${SCRATCHNODE}/${SAMPLE_NAME}.aln-pe.bam #sort by readname
echo I have sorted the .bam file and saved it as ${SCRATCHNODE}/${SAMPLE_NAME}.sort.bam

samtools view -f 0x2 -b ${SCRATCHNODE}/${SAMPLE_NAME}.sort.bam > ${SCRATCHNODE}/${SAMPLE_NAME}.sort.filt.bam # filter for proper pairs of reads
echo I have filtered the .bam file and saved it as ${SCRATCHNODE}/${SAMPLE_NAME}.sort.filt.bam

samtools fixmate -m ${SCRATCHNODE}/${SAMPLE_NAME}.sort.filt.bam ${SCRATCHNODE}/${SAMPLE_NAME}.fixmate.bam #add matescore tags
echo I have added matescore tags and saved as ${SCRATCHNODE}/${SAMPLE_NAME}.fixmate.bam

samtools sort -o ${SCRATCHNODE}/${SAMPLE_NAME}.positionsort.bam ${SCRATCHNODE}/${SAMPLE_NAME}.fixmate.bam #sorting
echo I have sorted and saved as ${SCRATCHNODE}/${SAMPLE_NAME}.positionsort.bam

samtools markdup -r ${SCRATCHNODE}/${SAMPLE_NAME}.positionsort.bam ${OUTDIR}/${SAMPLE_NAME}.rmdup.bam 
echo I have removed duplicates and saved as ${OUTDIR}/${SAMPLE_NAME}.rmdup.bam 

echo I am all done with using bwa and samtools to align $FORWARDREAD and $REVERSEREAD to $REFERENCE


#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
seff ${SLURM_JOBID}
