#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=20gb
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/new-resample-alpha200-spar025-dgn1-nsm4-log.txt
#SBATCH --job-name=resample-aa200-025-dgn1-nsm4




module load matlab

cd ~/Network-two-sample-test/
matlab -r "alpha=2.00;GraphonName1='NewDegenGraphon1';GraphonName2='NewSmoothGraphon4';A_sparse_power=-0.250;B_sparse_power=-0.250;new_degeneracy_no_alpha_benchmark_resample"
