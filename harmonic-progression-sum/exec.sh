#!/bin/bash

make clean && make
echo ""

nthreads=$(nproc)
ncores=$(grep "cpu cores" /proc/cpuinfo |sort -u |cut -d":" -f2)

for finput in *.in;
do
    fname=${finput%.*}

    echo "Input: $finput"
    md5serial=`md5sum serial.cpp | awk '{ print $1 }'`
    serialout="$md5serial-$fname.out"

    if [ -e "$serialout" ];
    then
        stime=$(cat $serialout)
    else 
        stime=$(/usr/bin/time -f "%e" ./serial < $finput 2>&1 > serial-$fname.out)
        echo $stime > $serialout
    fi 

    echo "  Serial time: $stime"
    echo ""

    for pinput in p*.cpp;
    do
        pname=${pinput%.*}

        ptime=$(/usr/bin/time -f "%e" ./$pname < $finput 2>&1 > $pname-$fname.out)
        echo "  Parallel time ($pname): $ptime"

        if [ "$ptime" != "0.00" ]
        then
            speedup=$(echo "$stime/$ptime" | bc -l | awk '{printf "%.2f\n",$0}')
            speedup=$(sed -r 's/,/\./' <<< $speedup)
            echo "  Speedup: $speedup"
            echo "  Threads: $nthreads"
            efficiency=$(echo "$speedup/$nthreads" | bc -l)
            echo "  Efficiency: $efficiency"
        else
            echo "  Parallel time was 0!"
        fi

        DIFF=$(diff serial-$fname.out $pname-$fname.out)
        if [ "$DIFF" != "" ]
        then
            echo "  TEST FAILED!"
        else
            echo "  TEST PASSED!"
        fi
        echo ""
    done
done