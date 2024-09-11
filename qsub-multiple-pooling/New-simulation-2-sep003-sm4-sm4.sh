#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=15 --mem=20gb
#SBATCH --output=/home/zhang.7824/Meijia-two-sample-test-Revision-1/pbs_logs/New-simulation-2-sep003-sm4-sm4-log.txt
#SBATCH --job-name=NewSimu2-sep003-sm4-sm4
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com

#SBATCH --mail-type=ALL

module load matlab

cd ~/Meijia-two-sample-test-Revision-1/
matlab -r "shift_amount = 0.03; GraphonName1 =  'SmoothGraphon4';  GraphonName2 =  'SmoothGraphon4';  sparsity_parameters_a = 1.0;  sparsity_parameters_b = 1.0; new_multiple_pooling"