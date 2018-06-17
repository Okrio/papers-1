#!/bin/bash


for eps_file in *.eps; do
  pdf_file=${eps_file%.*}.pdf
  echo $pdf_file
  convert $eps_file $pdf_file
done
