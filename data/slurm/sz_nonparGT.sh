#!/bin/bash
#SBATCH --job-name=sz_nonparGT.sh
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/sz_nonparGT.txt
#SBATCH --time=6-00:00
#SBATCH --nodes=1 --ntasks-per-node=1 --mem=10gb
#SBATCH --partition=stat
#SBATCH --qos=normal
cd /home/Magpie/Network-two-sample-test/data
module load intel
module load gnu
module load R
Rscript example_2_nonparGT.R