#!/bin/bash

outname="main"
ext_list=("blg" "bbl" "log" "dvi" "aux") # "pdf")
for ext in ${ext_list[@]}; do
  command="rm -f ${outname}.${ext}"
  echo $command
  eval $command
done
