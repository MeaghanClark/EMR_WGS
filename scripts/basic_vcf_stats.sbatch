#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=24:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=50G            # memory required per allocated CPU (or core)
#SBATCH --job-name=basic_stats    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/basic_stats/basic_stats_%A.out" 
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/basic_stats/basic_stats_%A.err"
#SBATCH --account=bradburd
##########

# basic_vcf_stats.sbatch
# M. Clark 09/23/2024, updated 09/23/2024

# use vcftools to calculate some basic statistics from vcfs

# define variables 
VCF='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/variants_highQual/EMR_highQual_SNPs_nomaf_chrom_drop.vcf.gz'
OUTDIR='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/stats_highQual/'
OUT_PREFIX='EMR_highQual_SNPs_nomaf_chrom_drop'

# allele frequencies --freq 
#vcftools --gzvcf $VCF --freq --out ${OUTDIR}/${OUT_PREFIX}_allele_freqs
#echo calculated allele frequencies

#vcftools --gzvcf $VCF --freq2 --out ${OUTDIR}/${OUT_PREFIX}_allele_freqs2
#echo calculated allele frequencies, without extra info

# individual depth --depth
#vcftools --gzvcf $VCF --depth --out ${OUTDIR}/${OUT_PREFIX}_ind_depth
#echo calculated ind depth

# individual heterozygosity --het 
#vcftools --gzvcf $VCF --het --out ${OUTDIR}/${OUT_PREFIX}_ind_het
#echo calculated ind het

# site depth --site-mean-depth
#vcftools --gzvcf $VCF --site-mean-depth --out ${OUTDIR}/${OUT_PREFIX}_site_depth
#echo calculated site depth

# singletons --singletons
#vcftools --gzvcf $VCF --singletons --out ${OUTDIR}/${OUT_PREFIX}_singletons
#echo calculated singletons

# FST
POPDIR='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/pops'
populations=($(ls ${POPDIR}/*.txt)) # get list of population files 

# loop thorugh populations and make pairs 

for (( i=0; i<${#populations[@]}; i++ )); do
    for (( j=i+1; j<${#populations[@]}; j++ )); do
        # Get the file paths for the two populations
        pop1=${populations[i]}
        pop2=${populations[j]}
        
        # Run vcftools Fst calculation
        vcftools --gzvcf $VCF \
                 --weir-fst-pop $pop1 \
                 --weir-fst-pop $pop2 \
                 --out ${OUTDIR}/${OUT_PREFIX}_fst_${pop1##*/}_${pop2##*/}
        
        echo "Calculated Fst for ${pop1##*/} vs ${pop2##*/}"
    done
done

wait 

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
