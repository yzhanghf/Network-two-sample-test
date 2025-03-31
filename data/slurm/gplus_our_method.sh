#!/bin/bash
#SBATCH --job-name=ego_ourmethod.sh
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/ego_ourmethod.txt
#SBATCH --time=2-00:00
#SBATCH --nodes=1 --ntasks-per-node=36 --mem=2gb
#SBATCH --partition=stat
#SBATCH --qos=normal
cd /home/Magpie/Network-two-sample-test/data
module load matlab
matlab -nodesktop -r "example_1_our_method"