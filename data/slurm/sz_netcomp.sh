#!/bin/bash
#SBATCH --job-name=sz_netcomp.sh
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/sz_netcomp.txt
#SBATCH --time=6-00:00
#SBATCH --nodes=1 --ntasks-per-node=1 --mem=10gb
#SBATCH --partition=stat
#SBATCH --qos=normal
cd /home/Magpie/Network-two-sample-test/data
module load python/3.7-conda4.5
source activate local
python example_2_netcomp.py
source deactivate