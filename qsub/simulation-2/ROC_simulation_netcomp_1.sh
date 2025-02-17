#!/bin/bash
#SBATCH --job-name=netcomp_1.sh
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/ROC_simulation_netcomp_1.txt
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=1 --mem=2gb
#SBATCH --partition=stat
#SBATCH --qos=normal
cd /home/Magpie/Network-two-sample-test/
module load python/3.7-conda4.5
source activate local
python simulation_2_benchmark_netcomp.py 100 
source deactivate