#!/bin/bash

usage () {
    echo -e "Run DEL pipeline on cluster. The only required parameter is -s\n\
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

event=DEL
rootDir=/users/hl7/analysis/SV
workingDir=$rootDir/sample/$sample
scriptOrigin=$rootDir/scripts/events/$event
scriptDir=$workingDir/scripts/$event
logDir=$workingDir/log/$event
progressFile=$workingDir/log/progress.events.txt

## DEL
mkdir -p $logDir $scriptDir
cp $scriptOrigin/* $scriptDir/
sed -i "s/sampleReplace/$sample/g" $scriptDir/*
if [[ $fromStep == "1" ]]; then
    rm -rf $logDir/${event}_stack.* $logDir/${event}_getStat.*
    cmd1=`qsub $scriptDir/01.${event}_stack.sub`
    cmd2=`qsub -W depend=afterok:$cmd1 $scriptDir/02.${event}_getStat.sub`
    cmd3=`qsub -W depend=afterok:$cmd1 $scriptDir/03.${event}_inheritance.sub`
    cmd4=`qsub -W depend=afterok:$cmd1 $scriptDir/04.${event}_denovo.sub`
    echo -e "Submitted: ${event}_stack, $cmd1" >> $progressFile
    echo -e "Submitted: ${event}_getStat, $cmd2" >> $progressFile
    echo -e "Submitted: ${event}_inheritance, $cmd3" >> $progressFile
    echo -e "Submitted: ${event}_denovo, $cmd4" >> $progressFile
elif [[ $fromStep == "2" ]]; then
    rm -rf $logDir/${event}_getStat.*
    cmd2=`qsub $scriptDir/02.${event}_getStat.sub`
    cmd3=`qsub $scriptDir/03.${event}_inheritance.sub`
    cmd4=`qsub $scriptDir/04.${event}_denovo.sub`
    echo -e "Submitted: ${event}_getStat, $cmd2" >> $progressFile
    echo -e "Submitted: ${event}_inheritance, $cmd3" >> $progressFile
    echo -e "Submitted: ${event}_denovo, $cmd4" >> $progressFile
elif [[ $fromStep == "3" ]]; then
    cmd3=`qsub $scriptDir/03.${event}_inheritance.sub`
    cmd4=`qsub $scriptDir/04.${event}_denovo.sub`
    echo -e "Submitted: ${event}_inheritance, $cmd3" >> $progressFile
    echo -e "Submitted: ${event}_denovo, $cmd4" >> $progressFile
elif [[ $fromStep == "4" ]]; then
    cmd4=`qsub $scriptDir/04.${event}_denovo.sub`
    echo -e "Submitted: ${event}_denovo, $cmd4" >> $progressFile
else
    echo "There's no step $fromStep, eixt"; exit 1
fi


