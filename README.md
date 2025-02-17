# Reproducing the results in JASA-TM-2024-0092-R2

This document serves the Round 3 revision of this paper.


## Hardware requirement:  computing cluster, such as Unity
* It is likely infeasible to run some simulations on personal computers.  Therefore, all reproducibility details are written for running on high-performance computing (HPC) clusters, such as Unity.  In this document, we will use Unity with Slurm queueing system.
* In this work, we use the word "Magpie" as the anonymized username.



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

1. Example 1: cd to 'data-examples' subfolder and run 'example1.m' in MATLAB
2. Example 2: cd to 'data-examples' subfolder and run 'example2.m' in MATLAB




