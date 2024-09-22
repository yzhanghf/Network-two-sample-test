#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=15 --mem=20gb
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/New-simulation-2-unmatched-sep004-sm2-sm2-log.txt
#SBATCH --job-name=NewSimu2-unmatched-sep004-sm2-sm2




module load matlab

cd ~/Network-two-sample-test/
matlab -r "shift_amount = 0.04; GraphonName1 =  'SmoothGraphon2';  GraphonName2 =  'SmoothGraphon2';  sparsity_parameters_a = 0.325;  sparsity_parameters_b = 0.325; new_unmatched_multiple_pooling"