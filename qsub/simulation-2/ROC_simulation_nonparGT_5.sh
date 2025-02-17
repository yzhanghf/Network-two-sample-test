#!/bin/bash
#SBATCH --job-name=nonparGT_5.sh
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/ROC_simulation_nonparGT.txt
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=1 --mem=2gb
#SBATCH --partition=stat
#SBATCH --qos=normal
cd /home/Magpie/Network-two-sample-test/
module load gnu
module load R
Rscript simulation_2_benchmark_nonparGT 1600 
