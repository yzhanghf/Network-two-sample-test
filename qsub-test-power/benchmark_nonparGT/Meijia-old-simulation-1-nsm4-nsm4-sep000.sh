#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=5 --mem=10gb
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/Meijia-nonparGT-1-nsm4-nsm4-sep000-log.txt
#SBATCH --job-name=RevMeijiaSimu1-nonparGT-nsm4-nsm4-sep000




module load gnu
module load R
module load matlab

cd ~/Network-two-sample-test/
matlab -r "shift_amount=0.00;GraphonName1 =  'NewSmoothGraphon4';  GraphonName2 =  'NewSmoothGraphon4';  sparsity_parameters_a = 1.0;  sparsity_parameters_b = 1.0;new_type1_benchmark_nonparGT_test_power_simulation"
