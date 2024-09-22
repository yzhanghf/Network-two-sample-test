#!/bin/bash
#SBATCH --job-name=Resample_1.sh
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/ROC_simulation_noderesample_1.txt
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=36 --mem=2gb
#SBATCH --partition=stat
#SBATCH --qos=normal
cd /home/Magpie/Network-two-sample-test/
module load matlab
matlab -nodesktop -r "n=100; node_resample_roc"