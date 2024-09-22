#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=20gb
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/new-simu-4-alpha225-spar050-dgn1-nbm1-log.txt
#SBATCH --job-name=NewSimu4-aa225-050-dgn1-nbm1




module load matlab

cd ~/Network-two-sample-test/
matlab -r "alpha=2.25;GraphonName1='NewDegenGraphon1';GraphonName2='NewBlockModel1';A_sparse_power=-0.50;B_sparse_power=-0.50;new_degeneracy_no_alpha"
