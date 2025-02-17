#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=20gb
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/new-simu-5-FDR-005-nbm1-nsm2-log.txt
#SBATCH --job-name=NewSimu5-FDR-005-nbm1-nsm2




module load matlab

cd ~/Network-two-sample-test/
matlab -r "graphon_shift = 0.05;GraphonName1='NewBlockModel1';GraphonName2='NewSmoothGraphon2';sparsity_parameters_a=1.0;sparsity_parameters_b=1.0;simulation_3_all"
