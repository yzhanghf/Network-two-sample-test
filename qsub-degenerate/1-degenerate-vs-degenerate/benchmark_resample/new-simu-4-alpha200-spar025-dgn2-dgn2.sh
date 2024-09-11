#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=2:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=10gb
#SBATCH --output=/home/zhang.7824/Meijia-two-sample-test-Revision-1/pbs_logs/new-resample-alpha200-spar025-dgn2-dgn2-log.txt
#SBATCH --job-name=NewSimu4-resample-aa200-025-dgn2-dgn2
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com

#SBATCH --mail-type=ALL

module load matlab

cd ~/Meijia-two-sample-test-Revision-1/
matlab -r "alpha=2.00;GraphonName1='NewDegenGraphon2';GraphonName2='NewDegenGraphon2';A_sparse_power=-0.25;B_sparse_power=-0.25;new_degeneracy_benchmark_resample"
