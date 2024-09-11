#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=2:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=5gb
#SBATCH --output=/home/zhang.7824/Meijia-two-sample-test-Revision-1/pbs_logs/new-subsample-alpha175-spar012-dgn1-dgn2-log.txt
#SBATCH --job-name=NewSimu4-subsample-aa175-012-dgn1-dgn2
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com

#SBATCH --mail-type=ALL

module load matlab

cd ~/Meijia-two-sample-test-Revision-1/
matlab -r "alpha=1.75;GraphonName1='NewDegenGraphon1';GraphonName2='NewDegenGraphon2';A_sparse_power=-0.125;B_sparse_power=-0.125;new_degeneracy_benchmark_subsample"
