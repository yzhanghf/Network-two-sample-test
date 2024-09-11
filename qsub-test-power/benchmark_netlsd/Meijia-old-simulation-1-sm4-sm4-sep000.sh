#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=5 --mem=10gb
#SBATCH --output=/home/zhang.7824/Meijia-two-sample-test-Revision-1/pbs_logs/Meijia-netlsd-1-sm4-sm4-sep000-log.txt
#SBATCH --job-name=RevMeijiaSimu1-netlsd-sm4-sm4-sep000
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com

#SBATCH --mail-type=ALL

module load python/3.7-conda4.5
module load matlab

cd ~/Meijia-two-sample-test-Revision-1/
matlab -r "shift_amount=0.00;GraphonName1 =  'SmoothGraphon4';  GraphonName2 =  'SmoothGraphon4';  sparsity_parameters_a = 1.0;  sparsity_parameters_b = 1.0;new_type1_benchmark_netlsd_test_power_simulation"
