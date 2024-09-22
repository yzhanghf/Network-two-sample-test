#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=2:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=10gb
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/new-subsample-alpha200-spar050-dgn1-nsm2-log.txt
#SBATCH --job-name=subsample-aa200-050-dgn1-nsm2




module load matlab

cd ~/Network-two-sample-test/
matlab -r "alpha=2.00;GraphonName1='NewDegenGraphon1';GraphonName2='NewSmoothGraphon2';A_sparse_power=-0.50;B_sparse_power=-0.50;new_degeneracy_no_alpha_benchmark_subsample"
