#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=20gb
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/NewSimu3-sm4-sm4-sep000-log.txt
#SBATCH --job-name=NewSimu3-sm4-sm4-sep000




module load matlab

cd ~/Network-two-sample-test/
matlab -r "shift_amount = 0.00;GraphonName1 =  'SmoothGraphon4';  GraphonName2 =  'SmoothGraphon4';  sparsity_parameters_a = 1.0;  sparsity_parameters_b = 1.0;new_test_power_simulation"
