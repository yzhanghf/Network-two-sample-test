#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=2:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=5gb
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/new-simu-4-alpha175-spar033-dgn2-nbm1-log.txt
#SBATCH --job-name=NewSimu4-aa175-033-dgn2-nbm1




module load matlab

cd ~/Network-two-sample-test/
matlab -r "alpha=1.75;GraphonName1='NewDegenGraphon2';GraphonName2='NewBlockModel1';A_sparse_power=-0.33;B_sparse_power=-0.33;simulation_5_all"
