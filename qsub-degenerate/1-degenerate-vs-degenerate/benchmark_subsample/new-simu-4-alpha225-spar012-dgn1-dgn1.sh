#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=20gb
#SBATCH --output=/home/zhang.7824/Meijia-two-sample-test-Revision-1/pbs_logs/new-subsample-alpha225-spar012-dgn1-dgn1-log.txt
#SBATCH --job-name=NewSimu4-subsample-aa225-012-dgn1-dgn1
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com

#SBATCH --mail-type=ALL

module load matlab

cd ~/Meijia-two-sample-test-Revision-1/
matlab -r "alpha=2.25;GraphonName1='NewDegenGraphon1';GraphonName2='NewDegenGraphon1';A_sparse_power=-0.125;B_sparse_power=-0.125;new_degeneracy_benchmark_subsample"
