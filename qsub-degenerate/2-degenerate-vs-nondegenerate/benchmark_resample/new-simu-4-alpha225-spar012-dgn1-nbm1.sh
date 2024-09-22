#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=20gb
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/new-resample-alpha225-spar012-dgn1-nbm1-log.txt
#SBATCH --job-name=resample-aa225-012-dgn1-nbm1




module load matlab

cd ~/Network-two-sample-test/
matlab -r "alpha=2.25;GraphonName1='NewDegenGraphon1';GraphonName2='NewBlockModel1';A_sparse_power=-0.125;B_sparse_power=-0.125;new_degeneracy_no_alpha_benchmark_resample"
