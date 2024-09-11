#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=1 --mem=10gb
#SBATCH --output=/home/zhang.7824/Meijia-two-sample-test-Revision-1/pbs_logs/Meijia-nonparGT-1-sm2-sm4-log.txt
#SBATCH --job-name=RevMeijiaSimu1-nonparGT-sm2-sm4
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com

#SBATCH --mail-type=ALL

module load gnu
module load R
module load matlab

cd ~/Meijia-two-sample-test-Revision-1/
matlab -r "shift_amount=0;GraphonName1 =  'SmoothGraphon2';  GraphonName2 =  'SmoothGraphon4';  sparsity_parameters_a = 0.325;  sparsity_parameters_b = 1.0;new_type1_benchmark_nonparGT_test_power_simulation"
