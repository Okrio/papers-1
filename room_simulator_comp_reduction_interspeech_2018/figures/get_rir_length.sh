#!/bin/bash


# MTR3 room configurations
input_sstable=/placer/prod/home/speech-placer/speech/mtr/room_configurations/mtr3/NOISY_TRAIN_3m_2mics/mtr3_3m_NOISY_TRAIN_room_config@300
limit_size=100000

gqui from $input_sstable proto speech.dsp.RoomConfiguration select target_source.impulse_response_at_microphone[0].sample.size_ limit $limit_size  --sstable_random_sampling=true  > target_length.txt

gqui from $input_sstable proto speech.dsp.RoomConfiguration select noise_source[0].impulse_response_at_microphone[0].sample.size_ limit $limit_size --sstable_random_sampling=true  > noise_length.txt

#gqui from $input_sstable proto speech.dsp.RoomConfiguration limit 100 --outfile=sstable:sample_room_configuration@1
