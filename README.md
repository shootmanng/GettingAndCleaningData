---
title: "README"
author: "Scott Hootman-Ng"
date: "2024-12-18"
---

The run_analysis.R script takes the data from https://archive.ics.uci.edu/dataset/240/human+activity+recognition+using+smartphones
provided during the Coursera course "Getting and Cleaning Data" and processes it as specified in said course. 
In particular, the script begins by merging the test and training data from
the original. It then adds the participant ID number and activity number to the table to give a complete dataframe. 
As specified from the aforementioned course, only variables denoting a mean or standard deviation are retained from the original variables.
From there the average of each of these variables is computed for each ID and activity and stored in the "result"" dataframe. Lastly, the activity numbers
are updated to their English word counterparts and the table is written to the text file
"tidytable.txt" in the current working directory.