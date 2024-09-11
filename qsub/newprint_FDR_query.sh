#!/bin/bash
#SBATCH --partition=stat
#SBATCH --time=1:00:00
#SBATCH --nodes=1 --ntasks-per-node=10 --mem=20gb
#SBATCH --output=/home/zhang.7824/Meijia-two-sample-test-Revision-1/pbs_logs/newprint_FDR_query.txt
#SBATCH --job-name=PrintFDRquery
#SBATCH --mail-user=ronaldaylmerfisher@gmail.com

#SBATCH --mail-type=ALL

module load matlab

cd ~/Meijia-two-sample-test-Revision-1/
matlab -r "for(calA_set_quantile=[0.1,0.2,0.3]);newprint_FDR_query;end;"
