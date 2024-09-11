#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=5 --mem=10gb
#SBATCH --output=/home/zhang.7824/Meijia-two-sample-test-Revision-1/pbs_logs/Meijia-NetComp-1-sm2-sm2-log.txt
#SBATCH --job-name=RevMeijiaSimu1-NetComp-sm2-sm2
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com

#SBATCH --mail-type=ALL

module load python/3.7-conda4.5
module load matlab

cd ~/Meijia-two-sample-test-Revision-1/
matlab -r "shift_amount=0;GraphonName1 =  'SmoothGraphon2';  GraphonName2 =  'SmoothGraphon2';  sparsity_parameters_a = 0.325;  sparsity_parameters_b = 0.325;new_type1_benchmark_netcomp_test_power_simulation"
