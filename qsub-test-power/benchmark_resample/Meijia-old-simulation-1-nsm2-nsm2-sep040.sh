#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=5 --mem=10gb
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/Meijia-resample-1-nsm2-nsm2-sep040-log.txt
#SBATCH --job-name=RevMeijiaSimu1-resample-nsm2-nsm2-sep040




module load python/3.7-conda4.5
module load matlab

cd ~/Network-two-sample-test/
matlab -r "shift_amount=0.40;GraphonName1 =  'NewSmoothGraphon2';  GraphonName2 =  'NewSmoothGraphon2';  sparsity_parameters_a = 1.0;  sparsity_parameters_b = 1.0;new_type1_benchmark_resample_test_power_simulation"
