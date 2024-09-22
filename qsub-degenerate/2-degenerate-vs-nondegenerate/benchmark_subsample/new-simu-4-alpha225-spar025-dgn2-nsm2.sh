#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=20gb
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/new-subsample-alpha225-spar025-dgn2-nsm2-log.txt
#SBATCH --job-name=subsample-aa225-025-dgn2-nsm2




module load matlab

cd ~/Network-two-sample-test/
matlab -r "alpha=2.25;GraphonName1='NewDegenGraphon2';GraphonName2='NewSmoothGraphon2';A_sparse_power=-0.250;B_sparse_power=-0.250;new_degeneracy_no_alpha_benchmark_subsample"
