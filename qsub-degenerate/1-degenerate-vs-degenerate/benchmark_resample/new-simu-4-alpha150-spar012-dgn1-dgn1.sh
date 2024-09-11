#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=2:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=5gb
#SBATCH --output=/home/zhang.7824/Meijia-two-sample-test-Revision-1/pbs_logs/new-resample-alpha150-spar012-dgn1-dgn1-log.txt
#SBATCH --job-name=NewSimu4-resample-aa150-012-dgn1-dgn1
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com

#SBATCH --mail-type=ALL

module load matlab

cd ~/Meijia-two-sample-test-Revision-1/
matlab -r "alpha=1.50;GraphonName1='NewDegenGraphon1';GraphonName2='NewDegenGraphon1';A_sparse_power=-0.125;B_sparse_power=-0.125;new_degeneracy_benchmark_resample"
