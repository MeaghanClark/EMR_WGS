#!/bin/bash

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=168:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=48G            # memory required per allocated CPU (or core)
#SBATCH --job-name=calc_frag    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/calc_frag/calc_frag_%A.out" 
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/calc_frag/calc_frag_%A.err"
#SBATCH --account=bradburd
##########

# Running bamPEFragmentSize sort and index

# load modules, updated to ubuntu
module purge
module load deepTools/3.5.5-foss-2023a
module load JAGS/4.3.2-foss-2023a
module load powertools
module list


BAMLIST=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/scripts/keys/rmdup_bamlist.txt
OUTREPORT=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/alignments/rmdup_frag_lengths.txt
OUTHIST=/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/alignments/rmdup_FragDist.png 

bamPEFragmentSize --bamfiles $BAMLIST --outRawFragmentLengths $OUTREPORT -o $OUTHIST


wait





# done

#print some environment variables to stdout for records
echo ----------------------------------------------------------------------------------------
echo PRINTING SUBSET OF ENVIRONMENT VARIABLES:
(set -o posix ; set | grep -v ^_ | grep -v ^EB | grep -v ^BASH | grep -v PATH | grep -v LS_COLORS)

echo ----------------------------------------------------------------------------------------
