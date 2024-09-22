# Reproducing the results in JASA-TM-2024-0092

This document serves the Round 2 revision of this paper.


## Hardware requirement:  computing cluster, such as Unity
* Simulations in this code are likely infeasible to run on personal computers.  Therefore, all reproducibility details are written for running on high-performance computing (HPC) clusters, such as Unity.  In this document, we will use Unity with Slurm queueing system.
* In this work, we use the word "Magpie" as the anonymized username.



## Steps to reproduce simulation results

0. [Preparation] Upload all contents of this repository to a unity folder, under the path:
	```
	/home/Magpie/Network-two-sample-test/
	```
	where recall that "Magpie" is the anonymized name.
	Please notice that the Unity server that you use to reproduce this code may have a different folder structure -- in which case, please also revise the Slurm scripts under the "slurm" subfolder accordingly.
	We also assume that "~" refers to the folder "/home/Magpie/".

1. [Preparation] Replace "Magpie" by your (reviewer's) own username.

	First, edit "folderlist.txt", replace "Magpie" there by your own username.
	Then in Unity commandline, run
	```
	sh changename.sh Magpie YOUR-OWN-USERNAME
	```

	For the remaining steps, whenever we need to describe folder paths, we will still use "Magpie" as the anonymized username.

2. [Preparation] Run the following commands to prepare folders to hold intermediate results, logs and plots
	```
	mkdir result new-result new-result-2-multiple-pooling new-result-degenerate-CI-coverage new-result-FDR new-result-test-power new-result-unmatched-multiple-pooling
	mkdir pbs_logs plots
	```

3. To reproduce Simulation 1 results: 
	From the main folder, run
	```
	cd qsub-type-I-error-and-power
	sh submit_all.sh
	cd ..
	```
	After all jobs finish, "cd" to the main folder and run
	```
	module load matlab
	matlab -r "newprint_coverage_heatmap"
	matlab -r "newprint_test_power"
	```

4. To reproduce Simulation 2 results:
	From the main folder, run
	```
	cd qsub-ROC
	sh submit_all.sh
	cd ..
	```
	After all jobs finish, "cd" to the main folder and run
	```
	module load matlab
	matlab -r "ROC_curver_plot_new"
	matlab -r "ROC_comparison_hist"
	```

5. To reproduce Simulation 3 results:
	From the main folder, run
	```
	cd qsub-FDR
	sh submit_all.sh
	cd ..
	```
	After all jobs finish, "cd" to the main folder and run
	```
	matlab -r "newprint_FDR_query"
	```


6. To reproduce Simulation 4 results:
	From the main folder, run
	```
	cd qsub-multiple-pooling
	sh submit_all.sh
	cd ..
	cd qsub-unmatched-multiple-pooling
	sh submit_all.sh
	cd ..
	```
	After all jobs finish, "cd" to the main folder and run
	```
	matlab -r "newprint_multiple_pooling"
	matlab -r "newprint_unmatched_multiple_pooling"
	```

7. To reproduce Simulation 5 results:
	From the main folder, run
	```
	cd qsub-degenerate
	cd 1-degenerate-vs-degenerate
	sh submit_all.sh
	sh benchmark_resample/submit_all.sh
	sh benchmark_subsample/submit_all.sh
	cd ..
	cd 2-degenerate-vs-nondegenerate
	sh submit_all.sh
	sh benchmark_resample/submit_all.sh
	sh benchmark_subsample/submit_all.sh
	cd ..
	cd 3-degenerate-vs-nondegenerate_part_2
	sh submit_all.sh
	sh benchmark_resample/submit_all.sh
	sh benchmark_subsample/submit_all.sh
	cd ..
	cd ..
	```
	After all jobs finish, "cd" to the main folder and run
	```
	matlab -r "newprint_degeneracy"
	```



## Steps to reproduce data example results

1. Example 1: Run 'data-examples/example1.m'
2. Example 2: Run 'data/examples/example2.m'




