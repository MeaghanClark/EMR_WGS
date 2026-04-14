#!/bin/bash --login
#SBATCH --job-name=snpeff_annotate
#SBATCH --time=168:00:00
#SBATCH --mem=12G
#SBATCH --cpus-per-task=1
#SBATCH --output=/mnt/home/clarkm89/snpEff/snpeff_annotate_%j.out
#SBATCH --error=/mnt/home/clarkm89/snpEff/snpeff_annotate_%j.err
#SBATCH --account=bradburd

# load correct Java version
module purge
module load Java/21.0.2
module list 

# move to snpEff install directory
cd /mnt/home/clarkm89/snpEff

INVCF="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/variants_highQual_indelMask/EMR_highQual_variants_nomaf_indelBuf_chrom.vcf.gz"
OUTVCF="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/variants_highQual_indelMask/EMR_highQual_variants_nomaf_indelBuf_chrom_snpeff_flt_codingOnly.vcf.gz"
STATS="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/snpEff/EMR_highQual_variants_nomaf_indelBuf_chrom_snpeff_flt_codingOnly.stats"

# java -Xmx8g -jar snpEff.jar GCA_039880765.1_rSisCat1 $INVCF > $OUTVCF

java -Xmx8g -jar snpEff.jar -stats $STATS -no-downstream -no-intergenic -no-intron -no-upstream -no-utr -v GCA_039880765.1_rSisCat1 $INVCF >  $OUTVCF

## END SCRIPT
