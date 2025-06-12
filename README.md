# Network two-sample test

Reproducing the results in "Higher-order accurate two-sample network inference and network hashing"

# Reference

* Higher-order accurate two-sample network inference and network hashing, arxiv: https://arxiv.org/abs/2208.07573
* BibTeX:
```bibtex
@article{shao2022higher,
  title={Higher-order accurate two-sample network inference and network hashing},
  author={Shao, Meijia and Xia, Dong and Zhang, Yuan and Wu, Qiong and Chen, Shuo},
  journal={Journal of the American Statistical Association},
  number={just-accepted},
  pages={1--27},
  year={2025+},
  publisher={Taylor \& Francis}
}
```

## Hardware requirement:  computing cluster, such as Unity
* It is likely infeasible to run some simulations on personal computers.  Therefore, all reproducibility details are written for running on high-performance computing (HPC) clusters, such as Unity.  In this document, we will use Unity with Slurm queueing system.
* In this work, we use the word "Magpie" as the anonymized username.

## Matlab files that encode our method

* Users who want to apply our method, please copy the entire "subroutine" subfolder, as the main method files still depend on a few further subroutines.
* ```subroutines/Our_method_classic.m```: Input two adjacency matrices and perform our proposed test.
* ```subroutines/Our_method_NetHashing.m``` and ```subroutines/Our_method_FastTest.m```: These code our hashing and fast test method.  Run the hashing to compress each individual network into a sequence of summary statistics.  Then run the second to perform our method based on these summary statistics, without needing to access the original adjacency matrices.



## Steps to reproduce simulation results

0. [Preparation] Upload all contents of this repository to a unity folder, under the path:
	```
	/home/Magpie/Network-two-sample-test/
	```
	where recall that "Magpie" is the anonymized name.
	Please notice that the Unity server that you use to reproduce this code may have a different folder structure -- in which case, please also revise the Slurm scripts under the "slurm" subfolder accordingly.
	We also assume that "~" refers to the folder "/home/Magpie/".

1. [Preparation] Replace "Magpie" by your own username.

	First, edit "folderlist.txt", replace "Magpie" there by your own username.
	Then in Unity commandline, run
	```
	sh changename.sh Magpie YOUR-OWN-USERNAME
	```

	For the remaining steps, whenever we need to describe folder paths, we will still use "Magpie" as the anonymized username.

2. [Preparation] Run the following commands to prepare folders to hold intermediate results, logs and plots
	```
	mkdir results pbs_logs plots
	```

3. To reproduce Simulation 1 results: 
	From the main folder, run
	```
	cd qsub/simulation-1
	sh submit_all.sh
	cd ..
	cd ..
	```
	After all jobs finish, from the main folder, run
	```
	module load matlab
	matlab -r "print_simulation_1_results"
	```

4. To reproduce Simulation 2 results:
	From the main folder, run
	```
	cd qsub/simulation-2
	sh submit_all.sh
	cd ..
	cd ..
	```
	After all jobs finish, from the main folder, run
	```
	module load matlab
	matlab -r "print_simulation_2_results"
	```

5. To reproduce Simulation 3 results:
	From the main folder, run
	```
	cd qsub/simulation-3
	sh submit_all.sh
	cd ..
	cd ..
	```
	After all jobs finish, from the main folder, run
	```
	module load matlab
	matlab -r "print_simulation_3_results"
	```

6. To reproduce Simulation 4 results:
	From the main folder, run
	```
	cd qsub/simulation-4
	sh submit_all.sh
	cd ..
	cd ..
	```
	After all jobs finish, from the main folder, run
	```
	module load matlab
	matlab -r "print_simulation_4_results"
	```

7. To reproduce Simulation 5 results:
	From the main folder, run
	```
	cd qsub/simulation-5
	cd 1-degenerate-vs-degenerate
	sh submit_all.sh
	cd ..
	cd 2-degenerate-vs-nondegenerate
	sh submit_all.sh
	cd ..
	cd ..
	cd ..
	```
	After all jobs finish, from the main folder, run
	```
	module load matlab
	matlab -r "print_simulation_5_results"
	```



## Steps to reproduce data example results

1. Example 1:
	1. Preparation: download data from http://snap.stanford.edu/data/ego-Gplus.html (official website for this publically available data set) and unzip, place individual data files unzipped from "gplus.tar.gz" under subfolder "data/gplus", place "gplus_combined.txt" under subfolder "data".
	2. To reproduce our method's result: cd to "data" subfolder.  Submit the slurm job:
	```
	cd slurm
	sbatch gplus_our_method.sh
	cd ..
	```
	to output the plot.
	3. To reproduce the result of subsampling, submit the slurm job:
	```
	cd slurm
	sbatch gplus_subsample.sh
	cd ..
	```
	to output the plot.



2. Example 2: 
	1. It's recommended to request the data from the data owner, as specified in the ACC form accompanying this paper.  Alternatively, you may download the data file "Final_data.mat" from this repository and place it in the "data" subfolder.  However, please notice that this file is a "facsimile": artificial noise was added for privacy protection.  Consequently, the artificial noise may lead to some difference in reproduced results.
	2. To reproduce our method's result: cd to 'data' subfolder and submit the slurm job:
	```
	cd slurm
	sbatch sz_our_method.sh
	cd ..
	```
	3. To reproduce the results in benchmark methods, submit the following slurm jobs:

	```
	cd slurm
	sbatch sz_subsample.sh
	sbatch sz_nonparGT.sh
	sbatch sz_netcomp.sh
	cd ..
	```
	4. After all methods finish, run "example_2_plot_all_methods.m" in MATLAB to output the plots.


