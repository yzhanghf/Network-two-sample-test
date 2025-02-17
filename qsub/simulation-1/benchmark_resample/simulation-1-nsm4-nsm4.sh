#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=10gb
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/resample-1-nsm4-nsm4-log.txt
#SBATCH --job-name=RevMeijiaSimu1-resample-nsm4-nsm4





module load matlab

cd ~/Network-two-sample-test/
matlab -r "shift_amount=0;GraphonName1 =  'NewSmoothGraphon4';  GraphonName2 =  'NewSmoothGraphon4';  sparsity_parameters_a = 1.0;  sparsity_parameters_b = 1.0;simulation_1_benchmark_resample"
