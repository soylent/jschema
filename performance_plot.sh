#!/usr/local/bin/gnuplot
reset
set terminal dumb

set datafile separator ","

set xdata time
set timefmt "%s"
set xtics format "%b %d"

set xlabel "Commit time"
set ylabel "Benchmark (s)"

set grid
set multiplot

plot "./performance_data.csv" using 2:3 title "Parsing" with lines, \
     "./performance_data.csv" using 2:4 title "Validation" with lines
