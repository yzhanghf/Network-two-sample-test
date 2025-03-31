#!/bin/bash
#SBATCH --job-name=sz_subsample.sh
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/sz_subsample.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=36 --mem=2gb
#SBATCH --partition=stat
#SBATCH --qos=normal
cd /home/Magpie/Network-two-sample-test/data
module load matlab
matlab -nodesktop -r "example_2_subsample"