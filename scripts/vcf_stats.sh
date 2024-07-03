#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########

#SBATCH --time=168:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1         # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=400G            # memory required per allocated CPU (or core)
#SBATCH --job-name=vcf_stats      # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/vcf_stats/vcf_stats_%A.out"
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/vcf_stats/vcf_stats_%A.err"
#SBATCH --account=bradburd

##########

# load modules update to ubuntu
module purge
module load powertools
module load BCFtools/1.19-GCC-13.2.0
module load R/4.3.2-gfbf-2023a
module list 


# define variables
BCF='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/EMR_WGS_drop_norm_rename.bcf.gz' #CHECK
OUTFILE='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/EMR_WGS_drop_norm_rename.vcfstats'

# run code
CMD="(printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' 'CHR' 'POS' 'DP' 'NS' 'QUAL' 'MQ' 'RPBZ' 'MQBZ' 'BQBZ' 'FS' 'ExcHet' 'PV4_STRAND' 'PV4_BASEQ' 'PV4_MAPQ' 'PV4_POS' && bcftools query -f '%CHROM\t%POS\t%INFO/DP\t%INFO/NS\t%QUAL\t%MQ\t%INFO/RPBZ\t%INFO/MQBZ\t%INFO/BQBZ\t%INFO/FS\t%INFO/ExcHet\t%INFO/PV4{0}\t%INFO/PV4{1}\t%INFO/PV4{2}\t%INFO/PV4{3}\n' $BCF) > $OUTFILE"

printf "\n%s\n\n" "$CMD"
eval $CMD

wait

#find ${OUTFILE} > $OUTLIST # this line should crease a file OUTLIST that contains the path + name of OUTFILE 

# define variables
EXEC='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/qualSummaryStats.R'
OUTREPORT='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/EMR_drop_norm_rename.vcfstats.summary' 
OUTPLOT='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/EMR_drop_norm_rename_vcfstats_summary.pdf' 
OUTLIST='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/EMR_vcfstats_list.txt' 

# run code
CMD2="$EXEC $OUTLIST $OUTREPORT $OUTPLOT 3 4 5 6 7 8 9 10 11 12 13 14 15"
printf "\n%s\n\n" "$CMD2"
eval $CMD2


wait

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
