#!/bin/bash
#SBATCH --job-name=total_4.sh
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/ROC_simulation_total_4.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=36 --mem=2gb
#SBATCH --partition=stat
#SBATCH --qos=normal
cd /home/Magpie/Network-two-sample-test/
module load matlab
matlab -nodesktop -r "n=800; simulation_2_our_method_AUC_time"