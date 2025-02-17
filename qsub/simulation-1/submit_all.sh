for script in *.sh
do
    sbatch "$script"
done

cd benchmark_subsample
for script in *.sh
do
    sbatch "$script"
done
cd ..

cd benchmark_netcomp
for script in *.sh
do
    sbatch "$script"
done
cd ..

cd benchmark_netlsd
for script in *.sh
do
    sbatch "$script"
done
cd ..

cd benchmark_nonparGT
for script in *.sh
do
    sbatch "$script"
done
cd ..

cd benchmark_resample
for script in *.sh
do
    sbatch "$script"
done
cd ..