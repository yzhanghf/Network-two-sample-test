#!/bin/bash
#SBATCH --job-name=total_1.sh
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/ROC_simulation_total_1.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=36 --mem=2gb
#SBATCH --partition=stat
#SBATCH --qos=normal
cd /home/Magpie/Network-two-sample-test/
module load matlab
matlab -nodesktop -r "n=100; ROC_sim_pvalue"