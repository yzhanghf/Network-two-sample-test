#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=2:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=5gb
#SBATCH --output=/home/zhang.7824/Meijia-two-sample-test-Revision-1/pbs_logs/new-simu-4-alpha150-spar012-dgn2-nbm1-log.txt
#SBATCH --job-name=NewSimu4-aa150-012-dgn2-nbm1
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com

#SBATCH --mail-type=ALL

module load matlab

cd ~/Meijia-two-sample-test-Revision-1/
matlab -r "alpha=1.50;GraphonName1='NewDegenGraphon2';GraphonName2='NewBlockModel1';A_sparse_power=-0.125;B_sparse_power=-0.125;new_degeneracy_no_alpha"
