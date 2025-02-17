#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=10gb
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/simulation-1-sm4-sm4-log.txt
#SBATCH --job-name=RevMeijiaSimu1-sm4-sm4




module load matlab

cd ~/Network-two-sample-test/
matlab -r "GraphonName1 =  'SmoothGraphon4';  GraphonName2 =  'SmoothGraphon4';  sparsity_parameters_a = 1.0;  sparsity_parameters_b = 1.0;simulation_1_our_method"
