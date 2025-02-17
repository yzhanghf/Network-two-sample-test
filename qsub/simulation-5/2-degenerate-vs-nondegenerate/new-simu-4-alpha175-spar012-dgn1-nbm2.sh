#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=2:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=10gb
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/new-simu-4-alpha175-spar012-dgn1-nbm2-log.txt
#SBATCH --job-name=NewSimu4-aa175-012-dgn1-nbm2




module load matlab

cd ~/Network-two-sample-test/
matlab -r "alpha=1.75;GraphonName1='NewDegenGraphon1';GraphonName2='NewBlockModel2';A_sparse_power=-0.125;B_sparse_power=-0.125;simulation_5_all"
