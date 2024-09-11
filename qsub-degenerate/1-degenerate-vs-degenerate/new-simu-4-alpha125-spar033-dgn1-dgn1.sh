#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=2:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=5gb
#SBATCH --output=/home/zhang.7824/Meijia-two-sample-test-Revision-1/pbs_logs/new-simu-4-alpha125-spar033-dgn1-dgn1-log.txt
#SBATCH --job-name=NewSimu4-aa125-033-dgn1-dgn1
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com

#SBATCH --mail-type=ALL

module load matlab

cd ~/Meijia-two-sample-test-Revision-1/
matlab -r "alpha=1.25;GraphonName1='NewDegenGraphon1';GraphonName2='NewDegenGraphon1';A_sparse_power=-0.33;B_sparse_power=-0.33;new_degeneracy_no_alpha"
