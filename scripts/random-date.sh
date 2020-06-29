#!/bin/bash

start=2017
end=2020

# +00:00
timezone=$(date +%:z)

interv=$((end-start))
sstart=$(date -d "$start-01-01" +%s)
num=$(shuf -i 0-$interv -n 1)
day=$(shuf -i 1-365 -n 1)
time=$(shuf -i 0-86399 -n 1)
yrs=$(( (num*365+day)*86400))
end=$((sstart+yrs+time))

tdate=$(date -d @$end +%Y-%m-%dT%H:%M:%S$timezone)

echo "$tdate"
