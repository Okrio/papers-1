#!/bin/bash

pdflatex main
bibtex main
pdflatex main
pdflatex main
#dvipdf main
