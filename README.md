# SVgoback
SV calling initiated from the GOBACK project, but become a general pipeline on HGSC cluster

## Caller
### breakdancer
* Calls: DEL INS INV ITX CTX
* SVtyper genotyped
* filter: for DEL and INV, based on SVtyper, genotype 0/1 or 1/1, and QUAL>1

### cnvnator
* Calls: DEL DUP CNV
* It's own genotyper, can call CNV
* No filtering applied afterwards

