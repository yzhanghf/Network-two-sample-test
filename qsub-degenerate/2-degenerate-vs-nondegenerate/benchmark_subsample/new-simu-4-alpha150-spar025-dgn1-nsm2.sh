#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=2:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=5gb
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/new-subsample-alpha150-spar025-dgn1-nsm2-log.txt
#SBATCH --job-name=subsample-aa150-025-dgn1-nsm2




module load matlab

cd ~/Network-two-sample-test/
matlab -r "alpha=1.50;GraphonName1='NewDegenGraphon1';GraphonName2='NewSmoothGraphon2';A_sparse_power=-0.250;B_sparse_power=-0.250;new_degeneracy_no_alpha_benchmark_subsample"
