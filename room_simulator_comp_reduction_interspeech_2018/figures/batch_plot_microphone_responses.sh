#!/bin/bash
bin="plot_microphone_magnitude_phase_difference.py"
python $bin "figure_data/2_0_90_rir_anechoic_16k.wav"
python $bin "figure_data/2_45_90_rir_anechoic_16k.wav"
python $bin "figure_data/2_91_90_rir_anechoic_16k.wav"
python $bin "figure_data/2_135_90_rir_anechoic_16k.wav"
python $bin "figure_data/2_180_90_rir_anechoic_16k.wav"
python $bin "figure_data/2_270_90_rir_anechoic_16k.wav"
