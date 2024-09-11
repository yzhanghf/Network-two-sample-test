#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=5 --mem=10gb
#SBATCH --output=/home/zhang.7824/Meijia-two-sample-test-Revision-1/pbs_logs/Meijia-subsample-1-nsm2-nsm2-sep040-log.txt
#SBATCH --job-name=RevMeijiaSimu1-subsample-nsm2-nsm2-sep040
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com

#SBATCH --mail-type=ALL

module load python/3.7-conda4.5
module load matlab

cd ~/Meijia-two-sample-test-Revision-1/
matlab -r "shift_amount=0.40;GraphonName1 =  'NewSmoothGraphon2';  GraphonName2 =  'NewSmoothGraphon2';  sparsity_parameters_a = 1.0;  sparsity_parameters_b = 1.0;new_type1_benchmark_subsample_test_power_simulation"
