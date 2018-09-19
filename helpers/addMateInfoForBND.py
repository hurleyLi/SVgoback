#!/usr/bin/env python

'''
This script is to add mate chrom INFO and mate END info 
for BND SV calls, using information on the ALT column
'''

import sys
inputF = sys.argv[1]

header1 = u'##INFO=<ID=MATE_CHR,Number=1,Type=String,Description="mate chr for BND">'
header2 = u'##INFO=<ID=MATE_END,Number=1,Type=Integer,Description="mate end for BND">'

with open(inputF) as f:
    for line in f:
        line = line.strip()
        if line[:2] == '##':
            print(line)
        elif line[0] == '#':
            print(header1)
            print(header2)
            print(line)
        else:
            line = line.split('\t')
            if ('[' in line[4]) or (']' in line[4]):
                if '[' in line[4]:
                    alt = line[4].split('[')
                else:
                    alt = line[4].split(']')
                mate = alt[1].split(':')
                mate_chr = mate[0]
                mate_end = mate[1]
                line[7] = 'MATE_CHR=' + mate_chr + ';MATE_END=' + mate_end + ';' + line[7]
            print('\t'.join(line))

