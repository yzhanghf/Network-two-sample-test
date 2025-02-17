#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=2:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=10gb
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/new-simu-4-alpha125-spar025-dgn1-nbm2-log.txt
#SBATCH --job-name=NewSimu4-aa125-025-dgn1-nbm2




module load matlab

cd ~/Network-two-sample-test/
matlab -r "alpha=1.25;GraphonName1='NewDegenGraphon1';GraphonName2='NewBlockModel2';A_sparse_power=-0.250;B_sparse_power=-0.250;simulation_5_all"
