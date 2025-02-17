#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=2:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=10gb
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/new-simu-4-alpha200-spar033-dgn1-dgn2-log.txt
#SBATCH --job-name=NewSimu4-aa200-033-dgn1-dgn2




module load matlab

cd ~/Network-two-sample-test/
matlab -r "alpha=2.00;GraphonName1='NewDegenGraphon1';GraphonName2='NewDegenGraphon2';A_sparse_power=-0.33;B_sparse_power=-0.33;simulation_5_all"
