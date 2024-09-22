#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=24:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=20gb
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/new-subsample-alpha225-spar050-dgn2-nsm4-log.txt
#SBATCH --job-name=subsample-aa225-050-dgn2-nsm4




module load matlab

cd ~/Network-two-sample-test/
matlab -r "alpha=2.25;GraphonName1='NewDegenGraphon2';GraphonName2='NewSmoothGraphon4';A_sparse_power=-0.50;B_sparse_power=-0.50;new_degeneracy_no_alpha_benchmark_subsample"
