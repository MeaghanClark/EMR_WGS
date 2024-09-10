#!/bin/bash --login

#--------------- EXECUTABLE ---------------

# This script saves vcf stats information on a bcf_file, in a region specified by REGION
# Last updated 09/04/2023 by MI Clark,based on script by T Linderoth

# load modules update to ubuntu
module purge
module load powertools
module load BCFtools/1.19-GCC-13.2.0
module list 


# define variables
MEGA_BCF='/mnt/scratch/clarkm89/EMR_WGS/variants/EMR_WGS_norm.bcf.gz' #CHECK
REGION='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/chrom_200/chrom_list_${SLURM_ARRAY_TASK_ID}.txt'
OUTFILE='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/vcfstats/EMR_WGS_norm_${SLURM_ARRAY_TASK_ID}.vcfstats'

# run code
CMD="(printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' 'CHR' 'POS' 'DP' 'NS' 'QUAL' 'MQ' 'RPBZ' 'MQBZ' 'BQBZ' 'ExcHet' 'PV4_STRAND' 'PV4_BASEQ' 'PV4_MAPQ' 'PV4_POS' && \
bcftools query -f '%CHROM\t%POS\t%INFO/DP\t%INFO/NS\t%QUAL\t%MQ\t%INFO/RPBZ\t%INFO/MQBZ\t%INFO/BQBZ\t%INFO/ExcHet\t%INFO/PV4{0}\t%INFO/PV4{1}\t%INFO/PV4{2}\t%INFO/PV4{3}\n' -R $REGION  $MEGA_BCF) > $OUTFILE"

# CMD="(printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' 'CHR' 'POS' 'DP' 'NS' 'QUAL' 'MQ' 'RPBZ' 'MQBZ' 'BQBZ' 'ExcHet' 'PV4_STRAND' 'PV4_BASEQ' 'PV4_MAPQ' 'PV4_POS' && bcftools query -f '%CHROM\t%POS\t%INFO/DP\t%INFO/NS\t%QUAL\t%MQ\t%INFO/RPBZ\t%INFO/MQBZ\t%INFO/BQBZ\t%INFO/ExcHet\t%INFO/PV4{0}\t%INFO/PV4{1}\t%INFO/PV4{2}\t%INFO/PV4{3}\n' $BCF) > $OUTFILE"

printf "\n%s\n\n" "$CMD"
eval $CMD

wait

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
