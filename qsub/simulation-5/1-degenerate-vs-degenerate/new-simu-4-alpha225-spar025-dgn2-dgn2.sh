#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=20gb
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/new-simu-4-alpha225-spar025-dgn2-dgn2-log.txt
#SBATCH --job-name=NewSimu4-aa225-025-dgn2-dgn2




module load matlab

cd ~/Network-two-sample-test/
matlab -r "alpha=2.25;GraphonName1='NewDegenGraphon2';GraphonName2='NewDegenGraphon2';A_sparse_power=-0.25;B_sparse_power=-0.25;simulation_5_all"
