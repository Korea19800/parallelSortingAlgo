# parallelSortingAlgo

For each sorting algorithm, I created four different versions of the sort:
 One that runs sequentially (uses no parallelism at all).
 One that runs using 2 processes in parallel.
 One that runs using 4 processes in parallel.
 One that runs using 8 processes in parallel.

So, the code eight different sorting functions: four different versions of two different sorting
algorithms: one is insertion sort and the other is quick sort.

For the testing portion, I can run several algorithms on lists of various sizes to see the
effects of the sort and the parallelism. 

For each version of the “slow” sort, you could test it on
random lists of size 5,000, 10,000, 25,000, 50,000, and 100,000. 

For each version of the “fast”
sort, you could test it on random lists of size 100,000, 250,000, 500,000, 1,000,000 and
5,000,000. 

Finally I could also test the built-in function lists:sort on the same size lists as the “fast”
sort. Run each test (on each algorithm) at least 5 times, average the results for each algorithm,
and record the data. 
