# SVgoback
SV calling initiated from the GOBACK project, but become a general pipeline on HGSC cluster

## Caller
### breakdancer
* Calls: DEL INS INV ITX CTX
* SVtyper genotyped (Does not genotype ITX CTX INS)
* Filter: for DEL and INV, based on SVtyper, genotype 0/1 or 1/1, and QUAL>1, others no filter

01. breakdancer_call.sub
02. breakdancer_svtyper.sub
03. breakdancer_categorize.sub

### cnvnator
* Calls: DEL DUP (also CNV based on read-depth)
* Use its own genotyper
* No filtering applied afterwards

01. cnvnator_call.sub
02. cnvnator_categorize.sub

### delly
* Calls: DEL DUP (tandem only, also CNV based on read-depth) INV CTX (as BND)
* Use its own genotyper
* Filter: based on genotype 0/1 or 1/1, and PASS for the site and for the sample

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


