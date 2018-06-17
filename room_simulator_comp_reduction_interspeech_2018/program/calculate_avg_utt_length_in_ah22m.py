#!/usr/bin/python


vs = 4.7
vs_weighting = 11971984
ime = 9.8
ime_weighting = 6544952
other = 3.7
other_weighting = 980511

avg = (vs * vs_weighting + ime * ime_weighting + other * other_weighting) / (vs_weighting + ime_weighting + other_weighting)

print (avg)

