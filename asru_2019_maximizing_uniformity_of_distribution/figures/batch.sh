#!/bin/bash

for file in `ls -1 *.eps`; do
  epstopdf $file
done
