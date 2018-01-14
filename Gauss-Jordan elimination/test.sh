#!/bin/bash
echo "Outputs from ./gje.o --fname=$1 --quiet=true --test=true"
echo "========================================================"
for i in `seq 1 3`
do
./gje.o --fname=$1 --quiet=true --test=true
echo "========================================================"
done
