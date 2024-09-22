#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=20gb
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/new-simu-5-FDR-004-nbm1-nsm4-log.txt
#SBATCH --job-name=NewSimu5-FDR-004-nbm1-nsm4




module load matlab

cd ~/Network-two-sample-test/
matlab -r "graphon_shift = 0.04;GraphonName1='NewBlockModel1';GraphonName2='NewSmoothGraphon4';sparsity_parameters_a=1.0;sparsity_parameters_b=1.0;new_FDR_query"
