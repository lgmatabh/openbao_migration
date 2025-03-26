#!/bin/sh 

echo "#### Step:  $0"

ls -al destination/*.json|wc -l
ls -al origin/*.json|wc -l
