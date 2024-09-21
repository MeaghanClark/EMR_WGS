#!/bin/bash --login

# troubleshooting code: 
source /etc/profile
module -b list
### 

# load modules 
module purge
module load powertools
module load Java/21.0.2
module load BCFtools/1.19-GCC-13.2.0
module load Perl-bundle-CPAN/5.38.0-GCCcore-13.2.0
module list

EXEC='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/insertAnnotations_emr.pl' # need to customize vcf header descriptions for emr based on vcf summary stats
BCF='/mnt/scratch/clarkm89/EMR_WGS/variants/EMR_WGS_norm.bcf.gz' 
OUTFILE='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/annotated_vcf/EMR_annotated_${SLURM_ARRAY_TASK_ID}.vcf.gz' # annotated VCF! 
GRPFILE='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/EMR_groups_qc.txt' # CHECK THAT THIS MATCHES ORDER OF INDIVIDUALS IN BCF
REGFILE='${CHROM_LIST_DIR}/chrom_list_${SLURM_ARRAY_TASK_ID}.txt'
BEDFILE='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/masks/bed_by_chrom/EMR_mask_${SLURM_ARRAY_TASK_ID}_fail.bed' # output from gen_masks.sbatch, double check file name! 

#SCAF=$(cat $REGFILE)
# trying -r, annotate by scaffold 
CMD="bcftools view -R $REGFILE --no-version $BCF | $EXEC --dpbounds 2587,7761 --hetbound 1e-4 --bed $BEDFILE --overwrite --genorep $GRPFILE | bgzip > $OUTFILE" 

printf "\n%s\n\n" "$CMD"
eval $CMD
wait

module purge 
module load tabixpp/1.1.2-GCC-12.3.0
module list

tabix -p vcf /mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/annotated_vcf/EMR_annotated_${SLURM_ARRAY_TASK_ID}.vcf.gz

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
