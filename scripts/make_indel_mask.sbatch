#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=168:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=50G            # memory required per allocated CPU (or core)
#SBATCH --job-name=pos_windel    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/indel_mask/indel_mask_%A.out" 
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/indel_mask/indel_mask_%A.err"
#SBATCH --account=bradburd
##########

# make_indel_mask.sbatch 
# written by M. Clark 12/20/2024
# This script takes a VCF file containing indels, and outputs a position file with the genomic positions of sites within 20 bp of an indel, based on the reference. 
# Indels should be left-aligned (via bcftools norm)
# If the indel at position n is an insertion, the buffer around it is n +/- 20
# If the indel at position n is a deletion, the buffer around it is n - 20 and n + length(REF) -1 + 20

# load modules 
module purge
module load BCFtools/1.19-GCC-13.2.0
module list

VCF_INDELS=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/allsites/highQualInds_Sites/EMR_allsitesHQ_indels_chrom.vcf.gz
VCF_ALLSITES=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/allsites/highQualInds_Sites/EMR_allsitesHQ_highQual_chrom.vcf.gz
POS=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/indels/EMR_indel_buffer_nomaf.pos

bcftools view -v indels $VCF_INDELS | \
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\n' | \
awk '{
    ref_len = length($3);  # Length of the REF allele
    start = $2 - 20;       # Start position (n - 20)
    end = $2 + ref_len - 1 + 20;  # End position (n + ref_len - 1 + 20)
    if (start < 0) start = 0;  # Ensure start is non-negative
    print $1 "\t" start "\t" end;  # Output in BED format
}' | \
bedtools intersect -a <(bcftools query -f '%CHROM\t%POS\t%POS\n' $VCF_ALLSITES) -b stdin -u | \
uniq -f 1 | awk -v OFS="\t" '{print $1, $2}' > $POS

### END SCRIPT

