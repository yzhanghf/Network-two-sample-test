#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=12:00:00
#SBATCH --nodes=1 --ntasks-per-node=5 --mem=10gb
#SBATCH --output=/home/Magpie/Network-two-sample-test/pbs_logs/NetComp-1-sm2-sm4-log.txt
#SBATCH --job-name=RevMeijiaSimu1-NetComp-sm2-sm4




module load python/3.7-conda4.5
module load matlab

cd ~/Network-two-sample-test/
matlab -r "shift_amount=0;GraphonName1 =  'SmoothGraphon2';  GraphonName2 =  'SmoothGraphon4';  sparsity_parameters_a = 0.325;  sparsity_parameters_b = 1.0;new_type1_benchmark_netcomp"
