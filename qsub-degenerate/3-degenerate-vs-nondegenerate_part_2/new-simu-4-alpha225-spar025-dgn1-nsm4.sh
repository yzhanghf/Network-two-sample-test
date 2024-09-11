#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=24:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=20gb
#SBATCH --output=/home/zhang.7824/Meijia-two-sample-test-Revision-1/pbs_logs/new-simu-4-alpha225-spar025-dgn1-nsm4-log.txt
#SBATCH --job-name=NewSimu4-aa225-025-dgn1-nsm4
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com

#SBATCH --mail-type=ALL

module load matlab

cd ~/Meijia-two-sample-test-Revision-1/
matlab -r "alpha=2.25;GraphonName1='NewDegenGraphon1';GraphonName2='NewSmoothGraphon4';A_sparse_power=-0.250;B_sparse_power=-0.250;new_degeneracy_no_alpha"
