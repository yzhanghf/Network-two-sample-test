#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=2:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=5gb
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/new-resample-alpha175-spar033-dgn2-nsm2-log.txt
#SBATCH --job-name=resample-aa175-033-dgn2-nsm2




module load matlab

cd ~/Network-two-sample-test/
matlab -r "alpha=1.75;GraphonName1='NewDegenGraphon2';GraphonName2='NewSmoothGraphon2';A_sparse_power=-0.33;B_sparse_power=-0.33;new_degeneracy_no_alpha_benchmark_resample"
