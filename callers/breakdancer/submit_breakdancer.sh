#!/bin/bash

usage () {
    echo -e "Run breakdancer pipeline on cluster. The only required parameter is -s\n\
You can also specify from which step to start using -f"
}

haveInput=false
fromStep=1

options=":hs:f:"

while getopts $options opt
do
  case $opt in
    h ) usage; exit;;
    s ) sample=$OPTARG; haveInput=true;;
    f ) fromStep=$OPTARG;;
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

tool=breakdancer
rootDir=/users/hl7/analysis/SV
inputDir=$rootDir/data
input=$inputDir/$sample.hgv.bam
workingDir=$rootDir/sample/$sample
scriptOrigin=$rootDir/scripts/callers/$tool
scriptDir=$workingDir/scripts/$tool
logDir=$workingDir/log/$tool
progressFile=$workingDir/log/progress.txt

# check input bam file
if [[ ! -s $input ]] || [[ ! -s $input.bai ]]; then
    echo "File $input or index does not exist, exit"
    exit 1
fi

## Breakdancer
mkdir -p $logDir $scriptDir
cp $scriptOrigin/* $scriptDir/
sed -i "s/sampleReplace/$sample/g" $scriptDir/*
if [[ $fromStep == "1" ]]; then
    rm -rf $logDir/${tool}_call.* $logDir/${tool}_svtyper.* $logDir/${tool}_categorize.*
    cmd1=`qsub $scriptDir/01.${tool}_call.sub`
    cmd2=`qsub -W depend=afterok:$cmd1 $scriptDir/02.${tool}_svtyper.sub`
    cmd3=`qsub -W depend=afterok:$cmd2 $scriptDir/03.${tool}_categorize.sub`
    echo -e "Submitted: ${tool}_call, $cmd1" >> $progressFile
    echo -e "Submitted: ${tool}_svtyper, $cmd2" >> $progressFile
    echo -e "Submitted: ${tool}_categorize, $cmd3" >> $progressFile
elif [[ $fromStep == "2" ]]; then
    rm -rf $logDir/${tool}_svtyper.* $logDir/${tool}_categorize.*
    cmd2=`qsub $scriptDir/02.${tool}_svtyper.sub`
    cmd3=`qsub -W depend=afterok:$cmd2 $scriptDir/03.${tool}_categorize.sub`
    echo -e "Submitted: ${tool}_svtyper, $cmd2" >> $progressFile
    echo -e "Submitted: ${tool}_categorize, $cmd3" >> $progressFile
elif [[ $fromStep == "3" ]]; then
    rm -rf $logDir/${tool}_categorize.*
    cmd3=`qsub $scriptDir/03.${tool}_categorize.sub`
    echo -e "Submitted: ${tool}_categorize, $cmd3" >> $progressFile
else
    echo "There's no step $fromStep, eixt"; exit 1
fi


