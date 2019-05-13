#!/bin/bash

pdflatex main
bibtex main
bibtex main
pdflatex main
pdflatex main
