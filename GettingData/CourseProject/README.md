`run_analysis.R` should be run from the directory where original data set is located. 

I.e. you need to set the working directory to the Samsung data directory and see this as the output of 
`ls -altr`

``` html
-rwxr-xr-x@  1 user  staff      80 Oct 10  2012 activity_labels.txt
-rwxr-xr-x@  1 user  staff   15785 Oct 11  2012 features.txt
-rwxr-xr-x@  1 user  staff    2809 Oct 15  2012 features_info.txt
drwxr-xr-x@  6 user  staff     204 Nov 29  2012 test
drwxr-xr-x@  6 user  staff     204 Nov 29  2012 train
-rwxr-xr-x@  1 user  staff    4453 Dec 10  2012 README.txt
```


The script doesn't take any parameters, and outputs a file named aggregatedDataSet.txt into the current directory