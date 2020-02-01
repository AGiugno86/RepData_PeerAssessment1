---
title: "Reproducible Research: Peer Assessment 1"
author: Andrea Giugno
output: 
  html_document:
    keep_md: true
---

First off, we need to load the libraries, which we will need to use throughout this project. Also, we create the directory to store our plots, if it does not exist already.

```r
library(dplyr)

if (!dir.exists("figures/")) {dir.create("figures/")}
```

## Loading and preprocessing the data
We unzip the downloaded archive and we create a dataframe from the csv file within.

```r
if (!file.exists("activity.csv")) {
  zipFile <- "activity.zip"
  unzip(zipfile = zipFile)
}

activityDf <- read.csv("activity.csv")
```

The elements in the "date" field  are not loaded in the correct format automatically, since their class is factor. A call to the function ```as.Date()``` fixes the issue quickly.

```r
activityDf$date <- as.Date(activityDf$date, format = "%Y-%m-%d")
```
## What is mean total number of steps taken per day?

We first compute the total number of steps measured each day, by means of the ```tapply()``` function. We can plot the histogram of the result with the base package, since the figure is simple.


```r
totStepsByDay <- tapply(activityDf$steps, activityDf$date, sum, na.rm=TRUE)

hist(totStepsByDay, breaks = 20, col = "red",
      main = "Frequency of the total number of steps by day",
      xlab = "Total steps by day", ylab = "Count")
```

<img src="PA1_template_files/figure-html/unnamed-chunk-4-1.png" style="display: block; margin: auto;" />
The mean and the median of the total number of steps read:

* **Mean:** 9354
* **Median:** 10395

Please note that the mean has been rounded to the nearest integer, since this is the data type of the number of steps.

## What is the average daily activity pattern?



## Imputing missing values



## Are there differences in activity patterns between weekdays and weekends?
