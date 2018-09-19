#!/bin/bash

usage () {
    echo "Run SV calling pipeline on cluster. The only required parameter is -s"
}

haveInput=false
breakdancer=true

options=":hs:b"

while getopts $options opt
do
  case $opt in
    h ) usage; exit;;
    s ) sample=$OPTARG; haveInput=true;;
    b ) breakdancer=false;;
    \?) echo "Unknown option: -$OPTARG" >&2; usage; exit 1;;
    : ) echo "Missing option argument for -$OPTARG" >&2; usage; exit 1;;
    * ) echo "Unimplemented option: -$OPTARG" >&2; usage; exit 1;;
  esac
done

###############################

if [[ $haveInput == "false" ]]; then
    usage; exit 1
fi

###############################

rootDir=/users/hl7/analysis/SV
inputDir=$rootDir/data
input=$inputDir/$sample.hgv.bam
workingDir=$rootDir/sample/$sample
scriptOrigin=$rootDir/scripts/callers

# check input bam file
if [[ ! -f $input ]]; then
    echo "File $input does not exist, exit"
    exit 1
fi

## Breakdancer
if [[ $breakdancer == "true" ]]; then
	scriptDir=$workingDir/scripts/breakdancer
    mkdir -p $workingDir/log/breakdancer $scriptDir
	cp $scriptOrigin/breakdancer/* $scriptDir/
	sed -i "s/sampleReplace/$sample/g" $scriptDir/*
	cmd1=`qsub $scriptDir/01.breakdancer_call.sub`
	cmd2=`qsub -W depend=afterok:$cmd1 $scriptDir/02.breakdancer_svtyper.sub`
	cmd3=`qsub -W depend=afterok:$cmd2 $scriptDir/03.breakdancer_categorize.sub`
fi












