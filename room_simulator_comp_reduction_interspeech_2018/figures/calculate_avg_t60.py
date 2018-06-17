#!/usr/bin/python

import numpy as np

# the information is obtained from:
# https://cs.corp.google.com/piper///depot/google3/speech/recipes/robustness/config/mtr3/generate_room_simulator_params.py

reverb_time = np.array([0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0])
hist_mtr3 = np.array([4.0, 6.0, 8.0, 10.0, 13.0, 17.0, 17.0, 13.0, 8.0, 4.0, 0.0])

print ((np.sum(reverb_time * hist_mtr3)) / np.sum(hist_mtr3))

# These values are "tweaked" ( by hand :-( ) from the above to prevent having an
# identical room response in training and testing
TEST_REVERB_DISTRIBUTION = np.array([
    [0.01, 4.0], [0.12, 6.0], [0.19, 8.0], [0.31, 10.0], [0.38, 13.0],
    [0.49, 17.0], [0.57, 17.0], [0.72, 13.0], [0.81, 8.0], [0.92, 4.0]])

print ((np.sum(TEST_REVERB_DISTRIBUTION[:, 0] * TEST_REVERB_DISTRIBUTION[:, 1]))
       / np.sum(TEST_REVERB_DISTRIBUTION[:, 1]))


# reverb distributions are skewed to match the snr distributions
# in the caco1 mtr set-up.
# These values come from the table
# speech/recipes/robustness/
# config/room_simulation_distribution_target_reverb_snr.pb
CACO1_TEST_REVERB_DISTRIBUTION = np.array([
    [0.0, 27.5], [0.1, 23.2], [0.2, 19.0], [0.3, 16.0], [0.4, 14.3]])


print ((np.sum(CACO1_TEST_REVERB_DISTRIBUTION[:, 0] * CACO1_TEST_REVERB_DISTRIBUTION[:, 1]))
       / np.sum(CACO1_TEST_REVERB_DISTRIBUTION[:, 1]))


