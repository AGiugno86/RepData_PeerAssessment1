library(lattice)

if (!dir.exists("figures2/")) {dir.create("figures2/")}
#######
## Loading and preprocessing the data
# Unzip (if necessary) and read the dataset
if (!file.exists("activity.csv")) {
  zipFile <- "activity.zip"
  unzip(zipfile = zipFile)
}

activityDf <- read.csv("activity.csv")
# Put the dates in the right format
activityDf$date <- as.Date(activityDf$date, format = "%Y-%m-%d")

#######
## What is mean total number of steps taken per day?

# First, compute the total number of steps taken per day using tapply.
totStepsByDay <- tapply(activityDf$steps, activityDf$date, sum, na.rm=TRUE)

#Make the histogram
png("figures2/totStepsPerDay.png", height = 480, width = 480, units = "px")
hist(totStepsByDay, breaks = 20, col = "red",
     main = "Frequency of the total number of steps by day",
     xlab = "Total steps by day", ylab = "Count")
dev.off()
#######
## Time series

# Aggregate
stepsPerInterval <- aggregate(steps ~ interval, activityDf, mean)

# To construct abline
m <- max(stepsPerInterval$steps)
print(m)
#stepsPerInterval[stepsPerInterval$steps == m,]
to.abline <- stepsPerInterval[stepsPerInterval$steps == m,]$interval

png(filename = "figures2/stepsPerInt.png", height = 480, width = 480, units = "px")
plot(stepsPerInterval$interval, stepsPerInterval$steps, type="l", lwd = 1.5,
     main = "Average number of steps per interval", xlab = "Interval",
     ylab = "Average steps")
abline(v = to.abline, lwd = 1, lty = 2, col = "red")
dev.off()

######
# Imputing missing values

sum(is.na(activityDf$steps))

completeDf <- activityDf

for (i in 1:nrow(completeDf)){
  if (is.na(completeDf[i,"steps"])){
    interval <- completeDf[i,"interval"]
    completeDf[i,"steps"] <- stepsPerInterval[stepsPerInterval$interval==interval,]$mean_steps
  }
}
  
imputedStepsByDay <- tapply(completeDf$steps, completeDf$date, sum)

png(filename = "figures2/Imputed.png", height = 480, width = 480, units = "px")
hist(imputedStepsByDay, breaks = 20, col = "green",
     main = "Frequency of the total number of steps by day with imputation",
     xlab = "Total steps by day", ylab = "Count")
dev.off()

#The new mean and median are:
new_mean <- round(mean(imputedStepsByDay))
new_median <- median(imputedStepsByDay)

######
# Weekdays vs weekends

Sys.setlocale("LC_TIME", "C")   #To have day names in english

is_weekday <- factor(weekdays(activityDf$date) %in% c("Saturday", "Sunday"),
                     labels = c("Weekday", "Weekend"))

to_plot <- aggregate(activityDf$steps ~ activityDf$interval + is_weekday,
                     activityDf, mean)
names(to_plot) <- c("interval", "is_weekday", "steps")

trellis.device(device="png", filename = "figures2/Weekdays.png")
xyplot(steps ~ interval | is_weekday, to_plot, type = "l", col = "red", layout = c(1,2), main = "Average number of steps per interval: Weekdays vs Weekends")
dev.off()