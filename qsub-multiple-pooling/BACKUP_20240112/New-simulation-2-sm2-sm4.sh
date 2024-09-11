#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=15 --mem=10gb
#SBATCH --output=/home/zhang.7824/Meijia-two-sample-test-Revision-1/pbs_logs/New-simulation-2-sm2-sm4-log.txt
#SBATCH --job-name=NewSimu2-sm2-sm4
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com

#SBATCH --mail-type=ALL

module load matlab

cd ~/Meijia-two-sample-test-Revision-1/
matlab -r "GraphonName1 =  'SmoothGraphon2';  GraphonName2 =  'SmoothGraphon4';  sparsity_parameters_a = 0.325;  sparsity_parameters_b = 1.0; new_multiple_pooling"