#!/bin/bash

icao=()

wgetoptions='-O- -q'
metarurl='http://tgftp.nws.noaa.gov/data/observations/metar/stations/__station__.TXT'
tafurl='http://tgftp.nws.noaa.gov/data/forecasts/taf/stations/__station__.TXT'

METAR=false
TAF=false

for input in "$@"
do
  if [[ ! $input =~ ^(([a-zA-Z0-9]{4})|(m)|(t))$ ]]
  then
    echo "illegal input:" $input
  else
    case $input in
      'm') METAR=true;;
      't') TAF=true;;
      *) icao+=(${input^^});;
    esac
  fi
done

for i in ${icao[@]}
do
  if [ $METAR == true -o $TAF == false ]
  then
    finalurl="${metarurl/__station__/$i}"
    wget $wgetoptions $finalurl | grep -v '^[0-9]\{4\}/[0-9]\{2\}/[0-9]\{2\}'
  fi
  if [ $TAF == true ]
  then
    finalurl="${tafurl/__station__/$i}"
    wget $wgetoptions $finalurl | grep -v '^[0-9]\{4\}/[0-9]\{2\}/[0-9]\{2\}'
    echo ""
  fi
done
