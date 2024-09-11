#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=2:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=5gb
#SBATCH --output=/home/zhang.7824/Meijia-two-sample-test-Revision-1/pbs_logs/new-simu-4-alpha175-spar025-dgn1-dgn2-log.txt
#SBATCH --job-name=NewSimu4-aa175-025-dgn1-dgn2
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com

#SBATCH --mail-type=ALL

module load matlab

cd ~/Meijia-two-sample-test-Revision-1/
matlab -r "alpha=1.75;GraphonName1='NewDegenGraphon1';GraphonName2='NewDegenGraphon2';A_sparse_power=-0.25;B_sparse_power=-0.25;new_degeneracy_no_alpha"
