#!/bin/bash --login

########## SBATCH Lines for Resource Request ##########

#SBATCH --time=4:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1         # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=200G            # memory required per allocated CPU (or core)
#SBATCH --job-name=bam_hists      # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/home/clarkm89/EMR_WGS/log_bamstats_hists/annotations_hist_%A.out"
#SBATCH --error="/mnt/home/clarkm89/EMR_WGS/log_bamstats_hists/annotations_hist_%A.err"

##########

# load modules
module purge
module load powertools
module load GCC/8.3.0 OpenMPI/3.1.4
module load GSL
module load R/4.0.2
module list 

# define variables
EXEC='$HOME/EMR_WGS/scripts/makeAnnotationHists.R'
DPFILE='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/raw_calls/EMR_norm_bcf_DP.txt'
HETFILE='/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/raw_calls/EMR_norm_bcf_ExcHet.txt'
OUTFILE='$HOME/EMR_WGS/variants/masks/annotations_histograms.pdf'

# make ExcHet file 
# bcftools query -f "%CHROM\t%POS\t%INFO/ExcHet\n" /mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/raw_calls/EMR_WGS_03222023_norm.bcf.gz > $HETFILE

# run code
CMD="$EXEC $DPFILE $HETFILE $OUTFILE"
printf "\n%s\n\n" "$CMD"
eval $CMD

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
seff ${SLURM_JOBID}
