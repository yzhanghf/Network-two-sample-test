#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=15 --mem=20gb
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/New-simulation-2-sep002-nsm2-nsm2-log.txt
#SBATCH --job-name=NewSimu2-sep002-nsm2-nsm2




module load matlab

cd ~/Network-two-sample-test/
matlab -r "shift_amount = 0.02; GraphonName1 =  'NewSmoothGraphon2';  GraphonName2 =  'NewSmoothGraphon2';  sparsity_parameters_a = 1.0;  sparsity_parameters_b = 1.0; simulation_4_matched"