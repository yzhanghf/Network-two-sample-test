#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=1:00:00
#SBATCH --nodes=1 --ntasks-per-node=10 --mem=20gb
#SBATCH --output=/home/zhang.7824/Meijia-two-sample-test-Revision-1/pbs_logs/newprint_test-power.txt
#SBATCH --job-name=PrintTestPower
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com

#SBATCH --mail-type=ALL

module load matlab

cd ~/Meijia-two-sample-test-Revision-1/
matlab -r "newprint_test_power"
