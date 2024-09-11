#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=20gb
#SBATCH --output=/home/zhang.7824/Meijia-two-sample-test-Revision-1/pbs_logs/new-simu-5-FDR-002-nsm2-nsm4-log.txt
#SBATCH --job-name=NewSimu5-FDR-002-nsm2-nsm4
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com

#SBATCH --mail-type=ALL

module load matlab

cd ~/Meijia-two-sample-test-Revision-1/
matlab -r "graphon_shift = 0.02;GraphonName1='NewSmoothGraphon2';GraphonName2='NewSmoothGraphon4';sparsity_parameters_a=1.0;sparsity_parameters_b=1.0;new_FDR_query"
