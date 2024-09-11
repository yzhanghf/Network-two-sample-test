#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=25 --mem=10gb
#SBATCH --output=/home/zhang.7824/Meijia-two-sample-test-Revision-1/pbs_logs/Meijia-old-simulation-1-nbm1-nbm1-log.txt
#SBATCH --job-name=RevMeijiaSimu1-nbm1-nbm1
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com

#SBATCH --mail-type=ALL

module load matlab

cd ~/Meijia-two-sample-test-Revision-1/
matlab -r "GraphonName1 =  'NewBlockModel1';  GraphonName2 =  'NewBlockModel1';  sparsity_parameters_a = 1.0;  sparsity_parameters_b = 1.0;new_T_hat_and_CI_coverage_simulation"
