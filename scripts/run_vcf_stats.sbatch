#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=48:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=48G            # memory required per allocated CPU (or core)
#SBATCH --job-name=vcf_stats    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/vcf_stats_plots/vcf_stats_%A.out" 
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/vcf_stats_plots/vcf_stats_%A.err"
#SBATCH --account=bradburd

# run_vcf_stats.sbatch
# M. Clark 09/24/2024

# This script runs bcftools stats and plot-vcfstats on an input VCF file

module purge
module load powertools
module load BCFtools/1.19-GCC-13.2.0
module load Perl-bundle-CPAN/5.38.0-GCCcore-13.2.0
module list


REF='/mnt/research/Fitz_Lab/ref/massasauga/EMR_ref_2021/Scatenatus_HiC_v1.1.fasta'
INVCF='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/variants_highQual/EMR_highQual_SNPs_nomaf_chrom.vcf.gz'
OUTSTATS='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/stats_highQual/EMR_highQual_SNPs_nomaf_chrom.vchk'
PLOT_DIR='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/stats_highQual/stats_plot/'

bcftools stats -F $REF -s - $INVCF > $OUTSTATS
plot-vcfstats -p $PLOT_DIR -s $OUTSTATS

# below code is for processing multiple files at once
#for i in {3..98}
#do
#bcftools stats -f PASS -F /mnt/research/Fitz_Lab/ref/massasauga/EMR_ref_2021/Scatenatus_HiC_v1.1.fasta -s - /mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/annotate_vcf/EMR_drop_norm_annotated_${i}.vcf.gz > /mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/vcf_stats/allsites/EMR_drop_norm_annotated_${i}.vchk
#plot-vcfstats -p /mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/vcf_stats_plots_${i} -s /mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/vcf_stats/allsites/EMR_drop_norm_annotated_${i}.vchk
#done


#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------

