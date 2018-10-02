# SVgoback
SV calling initiated from the GOBACK project, but become a general pipeline on HGSC cluster

## Caller
Further filter by excluding RLCR region. ITX and CTX are in pgl format, the others are in bed format.

### breakdancer
* Calls: DEL INS INV ITX CTX
* SVtyper genotyped (Does not genotype ITX CTX INS)
* Simple filter: for __DEL INV__, based on SVtyper, genotype 0/1 or 1/1, and QUAL>1;
for __INS ITX CTX__, require DP > 10

01. breakdancer_call.sub
02. breakdancer_svtyper.sub
03. breakdancer_categorize.sub

### cnvnator
* Calls: DEL DUP (also CNV based on read-depth)
* Use its own genotyper
* No simple filter applied

01. cnvnator_call.sub
02. cnvnator_categorize.sub

### delly
* Calls: DEL DUP (tandem only, also CNV based on read-depth) INV CTX (as BND)
* Use its own genotyper
* Simple filter: based on genotype 0/1 or 1/1, and PASS for the site and for the sample

01. delly_call.sub
02. delly_categorize.sub

### lumpy
* Calls: DEL DUP (tandem only) INV ITX (as BND) CTX (as BND)
* SVtyper genotyped
* Filter: based on SVtyper, genotype 0/1 or 1/1, and QUAL>1. Also only keep one record for ITX and CTX

01. lumpy_preprocess.sub
02. lumpy_call.sub
03. lumpy_svtyper.sub
04. lumpy_categorize.sub

### manta
* Calls: DEL DUP (tandem only) INS INV CTX (as BND)
* Use its own genotyper
* Filter: PASS for the site and for the sample. Also only keep one record for CTX

01. manta_call.sub
02. manta_categorize.sub

### tiddit
* Calls: DEP DUP (both disparse and tandem, also CNV based on read-depth) INV ITX (as BND) CTX (as BND)
* Use its own genotyper
* Filter: PASS for the site. Combine disparse and tandem duplications.

01. tiddit_call.sub
02. tiddit_categorize.sub

## Event
### DEL DUP INS INV
Further filter by limiting the size within (100bp,1Mb). And remove calls overlapping with RLCRs_no_Repeat_Masker.txt

#### DEL
* breakdancer
* cnvnator
* delly
* lumpy
* manta
* tiddit

#### DUP (both disparse and tandem)
* cnvnator
* delly
* lumpy
* manta
* tiddit

#### INV
* breakdancer
* delly
* lumpy
* manta
* tiddit

#### INS
* breakdancer
* manta

### ITX CTX
Remove calls overlapping with RLCRs_no_Repeat_Masker.txt

Output is in pgl format

#### ITX
* breakdancer
* delly
* lumpy
* manta
* tiddit

#### CTX
* breakdancer
* delly
* lumpy
* manta
* tiddit

### CNV
* cnvnator
* delly
* tiddit


