#!/bin/bash

# script for building Chapel to enable distributed program executing

echo "BUILDING CHAPEL..."
cd $CHPL_HOME

# Set environment variables to preferred configuration
source util/setchplenv.bash

# Set Gasnet as communication protocol
export CHPL_COMM=gasnet
export CHPL_COMM_SUBSTRATE=udp

# re-build Chapel
make

export GASNET_SPAWNFN=L

# make check is available but optional
make check

# Set Gasnet execution variables

echo "SETTING GASNET..."

# Use SSH to spawn jobs
export GASNET_SPAWNFN=S
# Which ssh command should be used? ssh is the default.
export GASNET_SSH_CMD=ssh
# Disable X11 forwarding
export GASNET_SSH_OPTIONS=-x
# Specify which hosts to spawn on.
export GASNET_SSH_SERVERS="52.226.78.109 52.226.75.78"

echo "COMPILING..."
cd ~/Desktop/eiti-porr/Gauss-Jordan\ elimination/
chpl -o gje-dist.o gje-dist.chpl

echo "EXECUTING..."

for i in `seq 1 3`
do
echo "$i ..."
./gje-dist.o --fname=$1 --quiet=true --numLocales=2
done

echo "CLEANING..."
rm -f *.o
