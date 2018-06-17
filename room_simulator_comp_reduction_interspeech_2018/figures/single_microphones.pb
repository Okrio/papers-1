# Test the effects of noise and reverberation case when we have one microphone.
#
# In this scenario, there is one microphone placed inside a room and there is
# a target source and a noise source located in different positions of the room.
#
# a) room_dimension: 5 meters x 4 meters x 3 meters along the x, y, and z 
#    directions respectively.
# b) microphone_array: Two microphones are placed at the center of the room. 
#    They are 2 centimeters apart along the y-axis.
# c) target_source: A certain distance away from the microphone, which is at 
#    the center of the room, along the x-axis.
# d) noise source: 1.5 meters away from the microphone, which is at the center
#    of the room. The azimuth angle is 30 degrees from the x-axis.
snr_db : 0

# Room dimension is 5 meters x 4 meters x 3 meters.
room_dimension {
  width : 5
  length : 4
  height : 3
}

reverberation_time_seconds : 0.2

# There is one microphone placed inside a room.
microphone_array {
  microphone_position {
    position_in_room {
      cartesian_coordinates {
        x : 2.049497475
        y : 1.450502525
        z : 1.00000000
      }
    }
  }
}

# The target source is 1.5 meters away from the microphone.
# But this is a dummy value and we will sweep values shown at the
# end of this file.
target_source {
  position {
    position_from_microphone_array_center {
      spherical_coordinates {
        r : 1.5
        theta :45 
        phi : 90
      }
    }
  }
  reference_distance : 1.0
}

# The noise source is 1.5 meters away from the microphone at the azimuth
# angle of 30 degrees.
noise_source {
  position {
    position_from_microphone_array_center {
      spherical_coordinates {
        r : 1.5
        theta : 75
        phi : 90
      }
    }
  }
  reference_distance : 1.0
}

# UtteranceAddNoiseMapper will eventually set the sampling rates, so the
# sampling rates are not set.

target_sampling_rate : 16000.0
noise_sampling_rate : 16000.0
simulation_output_sampling_rate : 16000.0
