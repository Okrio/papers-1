#!/bin/bash


# MTR3 room configurations
input_sstable=/placer/prod/home/speech-placer/speech/mtr/room_configurations/mtr3/NOISY_TRAIN_3m_2mics/mtr3_3m_NOISY_TRAIN_room_config@300
# Reverberation time should be .
#
# SNR 11.08 dB
# T_60 = 0.48 seconds
# 4000 samples
gqui from $input_sstable proto speech.dsp.RoomConfiguration  limit 10 where 'target_source.impulse_response_at_microphone[0].sample.size_ > 3800 and target_source.impulse_response_at_microphone[0].sample.size_ < 4200' --outfile=sstable:sample_room_configuration@1
