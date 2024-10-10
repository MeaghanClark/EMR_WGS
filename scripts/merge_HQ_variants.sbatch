#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=12:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=24G            # memory required per allocated CPU (or core)
#SBATCH --job-name=merge_HQ_var    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/flt_HQ_var/merge_HQ_var_%A.out" 
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/flt_HQ_var/merge_HQ_var_%A.err"
#SBATCH --account=bradburd
##########

# merge_HQ_variants.sbatch
# M. Clark 09/23/2024, updated 10/8/2024
# updated to make sure indels are removed 

# merge vcf high quality variants files and filter to retain desired autosomal chromosomes

# define variables 
# for variants:
#VCF_LIST='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/vcf_highQual_var_list.txt' # list of vcf file form flt_high_qual_snps.sbatch, in order of chromosome chunk
KEEP_CHROM='CM078115.1,CM078116.1,CM078117.1,CM078118.1,CM078119.1,CM078120.1,CM078121.1,CM078122.1,CM078123.1,CM078124.1,CM078125.1,CM078126.1,CM078127.1,CM078128.1,CM078129.1,CM078130.1,CM078131.1' #/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/ref_chromosome_list.txt   # list of chromosomes to retain in output VCF file
#OUTVCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/variants_highQual/EMR_highQual_variants_nomaf_chrom.vcf.gz

# for allsites:
VCF_LIST='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/vcf_highQual_allsites_list.txt' # list of vcf file form flt_high_qual_snps.sbatch, in order of chromosome chunk
OUTVCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/allsites/highQualInds_Sites/EMR_allsitesHQ_highQual_chrom.vcf.gz

while IFS= read -r line; do 
	tabix -p vcf $line
	#echo $line
done < $VCF_LIST

# concat high quality variants vcf files, then filter to only retain sites on autosomal chromosomes 
bcftools concat -f $VCF_LIST -a -r $KEEP_CHROM -Ou | bcftools view -i 'INDEL=0' -o $OUTVCF

tabix -p vcf $OUTVCF

wait 


#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
