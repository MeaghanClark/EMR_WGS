#!/bin/bash

# align_to_genome.sbatch
# This script uses bwa mem to aligned trimmed and QC-checked reads to a reference genome. 
# resulting sam files are converted to bam, then indexed, sorted, duplicates are removed, and read pair overlap trimmed
# Last updated 08/22/2024 by MI Clark, originally written by MI Clark and R Toczydlowski based on scripts by B Reid and T Linderoth

#--------------- EXECUTABLE ---------------

# This script aligns pairs of forward and reverse sequence files listed in a text file to the given reference and trims overlap between read pairs
# Input: Reference genome path, forward and reverse reads from wrapper-align_to_genome.sh 
#
# Output: ${SAMPLE_NAME}.trim.bam file, forward and reverse reads aligned to reference genome and trimmed

# load modules, updated to ubuntu
module purge
module load BWA/0.7.17-20220923-GCCcore-12.3.0
module load SAMtools/1.18-GCC-12.3.0
module load powertools
module list 
 
# required imports from wrapper: 
#	ARRAY_KEY
# 	REFERENCE
# 	CPUS
#	OUTDIR
#	SCRATCHNODE

line=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$ARRAY_KEY")

IFS=$'\t' read -r FORWARDREAD REVERSEREAD <<< "$line"
BASE=$(basename "$FORWARDREAD")
SAMPLE_NAME=$(echo "${BASE}" | cut -d "_" -f 1,2 | cut -d "." -f 2)

# text for troubleshooting
echo using $REFERENCE 
echo trying to locate files $FORWARDREAD and $REVERSEREAD
echo I will put the output in ${SCRATCHNODE}/${SAMPLE_NAME}.aln-pe.sam 

# generate read group information 

###
prevrg='N'
readgroup=''
nmatch=0
lstart=-3

# define data description based on data source 
if echo $SAMPLE_NAME | grep -q Scat; then
	DATADS='Whole genome sequences from eastern massasauga rattlesnakes from Mathur et al. 2023' # data description, e.g. 'Whole genome sequences from Florida scrub jays sequenced for the Mosaic project.'
elif echo $SAMPLE_NAME | grep -q scat; then
	DATADS='Whole genome sequences from eastern massasauga rattlesnakes from Mathur et al. 2023' # data description, e.g. 'Whole genome sequences from Florida scrub jays sequenced for the Mosaic project.'
else
	DATADS='Whole genome sequences from eastern massasauga rattlesnakes from Michigan sequenced for the EMR WGS project' # data description, e.g. 'Whole genome sequences from Florida scrub jays sequenced for the Mosaic project.'
fi

# need to check multiple headers to make sure sample barcodes converge (i.e. no sequencing error)
while [ $nmatch -lt 10 ]
do
	lstart=$((lstart + 4))
	lend=$((lstart + 1))
	readheader=$(zcat "$FORWARDREAD" | sed -n "${lstart}p;${lend}q" | sed 's/ [[:digit:]]//')
	readinfo=($(echo "$readheader" | perl -e 'chomp($read = <>); @arr = split(/:/,$read); print "@arr[2,3,$#arr]";'))
	barcode=$(sed 's/+/-/' <<< "${readinfo[2]}")
	readgroup="@RG\tID:${readinfo[0]}.${readinfo[1]}\tBC:${barcode}\tDS:${DATADS}\tLB:${samplib}\tPL:ILLUMINA\tPU:${readinfo[0]}.${readinfo[1]}.${barcode}\tSM:${SAMPLE_NAME}"

	if [ "$readgroup" = "$prevrg" ] && ! [[ "$barcode" =~ 'N' ]]; then ((nmatch++)); fi
	prevrg="$readgroup"
done

echo using $readgroup

###
#run bwa 
# for two sets of paired fastq files:
CMD="bwa mem -t $CPUS -R '$readgroup' $REFERENCE $FORWARDREAD $REVERSEREAD > ${SCRATCHNODE}/${SAMPLE_NAME}.aln-pe.sam"
printf "\n%s\n\n" "$CMD"
eval $CMD

wait


echo I have created a .sam file for $SAMPLE_NAME and put it in $SCRATCHNODE

 # run samtools
samtools view -Sb -o ${SCRATCHNODE}/${SAMPLE_NAME}.aln-pe.bam ${SCRATCHNODE}/${SAMPLE_NAME}.aln-pe.sam #change sam to bam
echo I have converted the .sam file to a .bam file and saved it in ${SCRATCHNODE}

# delete sam file
rm ${SCRATCHNODE}/${SAMPLE_NAME}.aln-pe.sam

samtools sort -n -o ${SCRATCHNODE}/${SAMPLE_NAME}.sort.bam ${SCRATCHNODE}/${SAMPLE_NAME}.aln-pe.bam #sort by readname
echo I have sorted the .bam file and saved it as ${SCRATCHNODE}/${SAMPLE_NAME}.sort.bam

samtools view -f 0x2 -b ${SCRATCHNODE}/${SAMPLE_NAME}.sort.bam > ${SCRATCHNODE}/${SAMPLE_NAME}.sort.filt.bam # filter for proper pairs of reads
echo I have filtered the .bam file and saved it as ${SCRATCHNODE}/${SAMPLE_NAME}.sort.filt.bam

samtools fixmate -m ${SCRATCHNODE}/${SAMPLE_NAME}.sort.filt.bam ${SCRATCHNODE}/${SAMPLE_NAME}.fixmate.bam #add matescore tags
echo I have added matescore tags and saved as ${SCRATCHNODE}/${SAMPLE_NAME}.fixmate.bam

samtools sort -o ${SCRATCHNODE}/${SAMPLE_NAME}.positionsort.bam ${SCRATCHNODE}/${SAMPLE_NAME}.fixmate.bam #sorting
echo I have sorted and saved as ${SCRATCHNODE}/${SAMPLE_NAME}.positionsort.bam

samtools markdup -r ${SCRATCHNODE}/${SAMPLE_NAME}.positionsort.bam ${SCRATCHNODE}/${SAMPLE_NAME}.rmdup.bam 
echo I have removed duplicates and saved as ${SCRATCHNODE}/${SAMPLE_NAME}.rmdup.bam 

echo I am all done with using bwa and samtools to align $FORWARDREAD and $REVERSEREAD to $REFERENCE

wait 

# delete intermediate files 
rm ${SCRATCHNODE}/${SAMPLE_NAME}.sort.bam
rm ${SCRATCHNODE}/${SAMPLE_NAME}.sort.filt.bam
rm ${SCRATCHNODE}/${SAMPLE_NAME}.positionsort.bam
echo I have deleted some of the intermediate files

# trim overlap
bam clipOverlap --in ${SCRATCHNODE}/${SAMPLE_NAME}.rmdup.bam --stats --out ${OUTDIR}/${SAMPLE_NAME}.trim.bam 

wait

# done

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
