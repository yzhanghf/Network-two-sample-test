#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=2:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=10gb
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/new-simu-4-alpha125-spar033-dgn2-nbm2-log.txt
#SBATCH --job-name=NewSimu4-aa125-033-dgn2-nbm2




module load matlab

cd ~/Network-two-sample-test/
matlab -r "alpha=1.25;GraphonName1='NewDegenGraphon2';GraphonName2='NewBlockModel2';A_sparse_power=-0.33;B_sparse_power=-0.33;new_degeneracy_no_alpha"
