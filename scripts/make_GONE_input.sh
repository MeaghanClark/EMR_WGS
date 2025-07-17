# Script to generate .ped and .map input files for GONE analysis
# M. Clark 10/2/2024

# Site name (present in individual name) should be provided through the command link

module purge
module load PLINK/1.9b_6.21-x86_64
module load BCFtools/1.19-GCC-13.2.0
module load powertools
module list

SITE=$1 # use standard input to get SITE, either BBI, ELF, GOU, GRA, HAL, MAN, PCC, or SEV
VCF=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/variants_highQual/EMR_highQual_SNPs_nomaf_chrom_drop.vcf.gz
FILES=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/variants_highQual/plink/all_SNPs/EMR_highQual_chrom_drop
OUTDIR=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/GONE/input
OUTNAME=${SITE}

# generate list of samples 
INDS=$(bcftools view $VCF | grep -m1 "^#CHROM" | cut -f 10- | tr "\t" "\n"  | grep $SITE | tr "\n" "," | sed 's/,$//')

MACRO=CM078115.1,CM078116.1,CM078117.1,CM078118.1,CM078119.1,CM078120.1,CM078121.1
# use bcftools view to retain only individuals from a given site, and filter out nonvariant sites of the new sample set 
# use plink to convert to .ped and .map files 
# to filter out micro chromosomes: -r $MACRO
bcftools view -s $INDS -r $MACRO -m2 -M2 -a $VCF | plink --vcf /dev/stdin --biallelic-only 'strict' --set-missing-var-ids @:# --vcf-half-call 'missing' --double-id --recode --allow-extra-chr --out ${OUTDIR}/${OUTNAME}

# replace chromosomes in .map file with numeric code 
INMAP=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/GONE/input/${SITE}.map
OUTMAP=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/GONE/input/${SITE}_test.map

awk '{
    if (!($1 in chr_map)) {
        chr_map[$1] = ++count
    }
    $1 = chr_map[$1]
    print
}' OFS="\t" $INMAP > $OUTMAP

# # replace old .bim with chr with new .map file with integers
mv $OUTMAP $INMAP





