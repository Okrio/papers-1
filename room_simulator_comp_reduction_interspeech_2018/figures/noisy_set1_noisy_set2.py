#!/usr/bin/python



dist = 0.6



TEST_DISTANCE_SNR_DISTRIBUTIONS = [
    HistogramBin(value=DistanceSnrDistribution(
        distance=UniformProto(0.2, 1),
        snr=HistogramProto([(3.2, 5), (6.3, 10), (8.9, 10), (12.1, 20),
                            (14.8, 30), (18.2, 30), (20.8, 20), (24.3, 10),
                            (26.7, 10), (30.2, 5)])),
                 selection_frequency=10),
    HistogramBin(value=DistanceSnrDistribution(
        distance=UniformProto(1, 2),
        snr=HistogramProto([(0.3, 5), (3.2, 10), (5.8, 10), (9.2, 20),
                            (12.1, 30), (15.3, 30), (17.7, 20), (21.4, 10),
                            (24.1, 10)])),
                 selection_frequency=15),
    HistogramBin(value=DistanceSnrDistribution(
        distance=UniformProto(2, 3),
        snr=HistogramProto([(0.2, 10), (2.9, 10), (6.2, 20), (9.3, 30),
                            (12.1, 30), (14.8, 20), (18.3, 10), (21.4, 10)])),
                 selection_frequency=20),
    HistogramBin(value=DistanceSnrDistribution(
        distance=UniformProto(3, 4),
        snr=HistogramProto([(0.3, 10), (3.2, 20), (6.2, 30), (8.9, 30),
                            (11.8, 20), (15.2, 10), (17.8, 10), (21.3, 5)])),
                 selection_frequency=15),
    # Distance 4-6m has identical SNR distributions.
    HistogramBin(value=DistanceSnrDistribution(
        distance=UniformProto(4, 5),
        snr=HistogramProto([(0.2, 20), (3.4, 30), (6.2, 30), (9.3, 20),
                            (12.1, 10), (14.8, 10), (18.4, 5), (20.8, 5)])),
                 selection_frequency=10),
    HistogramBin(value=DistanceSnrDistribution(
        distance=UniformProto(5, 6),
        snr=HistogramProto([(0.2, 20), (3.4, 30), (6.2, 30), (9.3, 20),
                            (12.1, 10), (14.8, 10), (18.4, 5), (20.8, 5)])),
                 selection_frequency=10),
    # Distance 6-10m has identical SNR distributions.
    HistogramBin(value=DistanceSnrDistribution(
        distance=UniformProto(6, 7),
        snr=HistogramProto([(0.3, 30), (2.8, 30), (5.7, 20), (8.9, 10),
                            (11.8, 10), (15.2, 5), (18.1, 5), (21.3, 5)])),
                 selection_frequency=8),
    HistogramBin(value=DistanceSnrDistribution(
        distance=UniformProto(7, 8),
        snr=HistogramProto([(0.3, 30), (2.8, 30), (5.7, 20), (8.9, 10),
                            (11.8, 10), (15.2, 5), (18.1, 5), (21.3, 5)])),
                 selection_frequency=6),
    HistogramBin(value=DistanceSnrDistribution(
        distance=UniformProto(8, 9),
        snr=HistogramProto([(0.3, 30), (2.8, 30), (5.7, 20), (8.9, 10),
                            (11.8, 10), (15.2, 5), (18.1, 5), (21.3, 5)])),
                 selection_frequency=4),
    HistogramBin(value=DistanceSnrDistribution(
        distance=UniformProto(9, 10),
        snr=HistogramProto([(0.3, 30), (2.8, 30), (5.7, 20), (8.9, 10),
                            (11.8, 10), (15.2, 5), (18.1, 5), (21.3, 5)])),
                 selection_frequency=2)]


# snr distributions are skewed to provide an
# approximation to the snr distributions in the caco1 mtr set-up.
# distance distribtuions are uniform approximations to the discrete
# distributions in caco1.
# The caco1 values come from the table speech/recipes/robustness/config/
# room_simulation_distribution_target_reverb_snr.pb
CACO1_TEST_DISTANCE_SNR_DISTRIBUTIONS = [
    HistogramBin(value=DistanceSnrDistribution(
        distance=UniformProto(0.1, 0.2),
        snr=HistogramProto([(5, 2.2), (10, 2.7), (15, 3.2), (20, 3.5),
                            (25, 3.7)])),
                 selection_frequency=4.8),
    HistogramBin(value=DistanceSnrDistribution(
        distance=UniformProto(0.2, 0.3),
        snr=HistogramProto([(5, 2.2), (10, 2.7), (15, 3.2), (20, 3.5),
                            (25, 3.7)])),
                 selection_frequency=4.4),
    HistogramBin(value=DistanceSnrDistribution(
        distance=UniformProto(0.3, 0.4),
        snr=HistogramProto([(5, 2.2), (10, 2.7), (15, 3.2), (20, 3.5),
                            (25, 3.7)])),
                 selection_frequency=4.1),
    HistogramBin(value=DistanceSnrDistribution(
        distance=UniformProto(0.4, 0.5),
        snr=HistogramProto([(5, 2.2), (10, 2.7), (15, 3.2), (20, 3.5),
                            (25, 3.7)])),
                 selection_frequency=3.5),
    HistogramBin(value=DistanceSnrDistribution(
        distance=UniformProto(0.5, 0.6),
        snr=HistogramProto([(5, 2.2), (10, 2.7), (15, 3.2), (20, 3.5),
                            (25, 3.7)])),
                 selection_frequency=3.3),
    HistogramBin(value=DistanceSnrDistribution(
        distance=UniformProto(0.6, 0.7),
        snr=HistogramProto([(5, 2.2), (10, 2.7), (15, 3.2), (20, 3.5),
                            (25, 3.7)])),
                 selection_frequency=3.0),
    HistogramBin(value=DistanceSnrDistribution(
        distance=UniformProto(0.7, 0.8),
        snr=HistogramProto([(5, 2.2), (10, 2.7), (15, 3.2), (20, 3.5),
                            (25, 3.7)])),
                 selection_frequency=2.9),
    HistogramBin(value=DistanceSnrDistribution(
        distance=UniformProto(0.8, 0.9),
        snr=HistogramProto([(5, 2.2), (10, 2.7), (15, 3.2), (20, 3.5),
                            (25, 3.7)])),
                 selection_frequency=2.7),
    HistogramBin(value=DistanceSnrDistribution(
        distance=UniformProto(0.9, 1.0),
        snr=HistogramProto([(5, 2.2), (10, 2.7), (15, 3.2), (20, 3.5),
                            (25, 3.7)])),
                 selection_frequency=2.7),
    HistogramBin(value=DistanceSnrDistribution(
        distance=UniformProto(1.0, 1.25),
        snr=HistogramProto([(5, 2.2), (10, 2.7), (15, 3.2), (20, 3.5),
                            (25, 3.7)])),
                 selection_frequency=2.4),
    HistogramBin(value=DistanceSnrDistribution(
        distance=UniformProto(1.25, 1.5),
        snr=HistogramProto([(5, 2.2), (10, 2.7), (15, 3.2), (20, 3.5),
                            (25, 3.7)])),
                 selection_frequency=2.5),
    HistogramBin(value=DistanceSnrDistribution(
        distance=UniformProto(1.5, 1.75),
        snr=HistogramProto([(5, 2.2), (10, 2.7), (15, 3.2), (20, 3.5),
                            (25, 3.7)])),
                 selection_frequency=2.3),
    HistogramBin(value=DistanceSnrDistribution(
        distance=UniformProto(1.75, 2.0),
        snr=HistogramProto([(5, 2.2), (10, 2.7), (15, 3.2), (20, 3.5),
                            (25, 3.7)])),
                 selection_frequency=2.5),
    HistogramBin(value=DistanceSnrDistribution(
        distance=UniformProto(2.0, 2.25),
        snr=HistogramProto([(5, 2.2), (10, 2.7), (15, 3.2), (20, 3.5),
                            (25, 3.7)])),
                 selection_frequency=2.3)]


