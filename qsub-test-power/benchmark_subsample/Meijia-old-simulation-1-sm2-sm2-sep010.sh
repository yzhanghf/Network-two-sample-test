#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=5 --mem=10gb
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/Meijia-subsample-1-sm2-sm2-sep010-log.txt
#SBATCH --job-name=RevMeijiaSimu1-subsample-sm2-sm2-sep010




module load python/3.7-conda4.5
module load matlab

cd ~/Network-two-sample-test/
matlab -r "shift_amount=0.10;GraphonName1 =  'SmoothGraphon2';  GraphonName2 =  'SmoothGraphon2';  sparsity_parameters_a = 0.325;  sparsity_parameters_b = 0.325;new_type1_benchmark_subsample_test_power_simulation"
