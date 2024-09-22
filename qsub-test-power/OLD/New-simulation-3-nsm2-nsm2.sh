#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=20gb
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/NewSimu3-nsm2-nsm2-log.txt
#SBATCH --job-name=NewSimu3-nsm2-nsm2




module load matlab

cd ~/Network-two-sample-test/
matlab -r "GraphonName1 =  'NewSmoothGraphon2';  GraphonName2 =  'NewSmoothGraphon2';  sparsity_parameters_a = 1.0;  sparsity_parameters_b = 1.0;new_test_power_simulation"
