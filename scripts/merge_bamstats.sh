#!/bin/bash

########## SBATCH Lines for Resource Request ##########
#SBATCH --time=12:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --cpus-per-task=1      # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem-per-cpu=20G            # memory required per allocated CPU (or core)
#SBATCH --job-name=merge_bamstats    # you can give your job a name for easier identification (same as -J)
#SBATCH --output="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/merge_bamstats/merge_%A.out" 
#SBATCH --error="/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/logs/merge_bamstats/merge_%A.err"
#SBATCH --account=bradburd
##########


cat /mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.1.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.Scate-ma1_1.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.Scate-ma1_2.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.Scate-ma1_3.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.Scate-ma1_4.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.Scate-ma1_5.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.Scate-ma1_6.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.Scate-ma1_7.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.Scate-ma1_8.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.Scate-ma1_9.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.Scate-ma1_10.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.2.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.Scate-ma2_1.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.Scate-ma2_2.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.Scate-ma2_3.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.Scate-ma2_4.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.Scate-ma2_5.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.Scate-ma2_6.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.Scate-ma2_7.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.Scate-ma2_8.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.Scate-ma2_9.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.Scate-ma2_10.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.3.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.4.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.5.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.6.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.7.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.8.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.9.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.10.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.11.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.12.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.13.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.14.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.15.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.16.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.17.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.18.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.19.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.20.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.21.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.22.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.23.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.24.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.25.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.26.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.27.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.28.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.29.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.30.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.31.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.32.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.33.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.34.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.35.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.36.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.37.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.38.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.39.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.40.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.41.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.42.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.43.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.44.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.45.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.46.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.47.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.48.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.49.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.50.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.51.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.52.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.53.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.54.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.55.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.56.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.57.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.58.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.59.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.60.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.61.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.62.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.63.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.64.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.65.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.66.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.67.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.68.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.69.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.70.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.71.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.72.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.73.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.74.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.75.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.76.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.77.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.78.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.79.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.80.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.81.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.82.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.83.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.84.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.85.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.86.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.87.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.88.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.89.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.90.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.91.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.92.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.93.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.94.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.95.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.96.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.97.bamstats \
/mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_all_qc.98.bamstats > /mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_ALL_temp.bamstats

echo merged bamstats files 

(head -n1 /mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_ALL_temp.bamstats && grep -v "depth" /mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_ALL_temp.bamstats) > /mnt/research/Fitz_Lab/projects/massasauga/EMR_WGS/variants/bamstats/EMR_ALL_qc_ordered.bamstats

