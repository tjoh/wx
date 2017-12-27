#!/bin/bash

icao=()

metarurl='-O- -q http://tgftp.nws.noaa.gov/data/observations/metar/stations/__station__.TXT'

for input in "$@"
do
  if [[ ! $input =~ ^[a-zA-Z0-9]{4}$ ]]
  then
    echo "illegal input:" $input
  else
    icao+=(${input^^})
  fi
done


for i in ${icao[@]}
do
  finalurl="${metarurl/__station__/$i}"
  wget $finalurl | grep $i
done
