#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=2:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=10gb
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/new-resample-alpha175-spar012-dgn1-nsm4-log.txt
#SBATCH --job-name=resample-aa175-012-dgn1-nsm4




module load matlab

cd ~/Network-two-sample-test/
matlab -r "alpha=1.75;GraphonName1='NewDegenGraphon1';GraphonName2='NewSmoothGraphon4';A_sparse_power=-0.125;B_sparse_power=-0.125;new_degeneracy_no_alpha_benchmark_resample"
