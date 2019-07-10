#!/bin/bash

latex main
bibtex main
latex main
latex main
dvipdf main
