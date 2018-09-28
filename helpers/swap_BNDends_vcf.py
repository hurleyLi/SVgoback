#!/usr/bin/env python

'''
this script is designed for sv vcf files after svtyper (may work for other files,
as long as the alt field has the CTX loation for the othre breakend)
it's used for swap the location of two breakend, so that chr on the pos
location is greater than the other breakend
This has to be done after calling addMateInfo.py
Do not check error, so be careful
'''

import sys
inputF = sys.argv[1]

with open(inputF) as f:
    for line in f:
        line = line.strip()
        if line[0] == '#':
            print(line)
        else:
            line = line.split('\t')
            line[4] = '.'
            chr1 = line[0]
            pos1 = line[1]
            info = line[7].split(';')
            chr2 = info[0][9:]
            pos2 = info[1][9:]
            newInfoList = ['MATE_CHR=' + chr1, 'MATE_END=' + pos1] + info[2:]
            newInfo = ';'.join(newInfoList)
            newLine = [chr2, pos2] + line[2:7] + [newInfo] + line[-2:]
            print('\t'.join(newLine))

