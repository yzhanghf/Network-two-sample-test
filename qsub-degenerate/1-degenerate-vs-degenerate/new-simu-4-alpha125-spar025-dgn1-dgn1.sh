#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=2:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=5gb
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/new-simu-4-alpha125-spar025-dgn1-dgn1-log.txt
#SBATCH --job-name=NewSimu4-aa125-025-dgn1-dgn1




module load matlab

cd ~/Network-two-sample-test/
matlab -r "alpha=1.25;GraphonName1='NewDegenGraphon1';GraphonName2='NewDegenGraphon1';A_sparse_power=-0.25;B_sparse_power=-0.25;new_degeneracy_no_alpha"
