# Standalone tools to be used with the Room Simulator.
#
# TODO(chanwcom) Consider moving some tools like
# single_wav_room_acoustics_simulation to this directory.
package(
    default_hdrs_check = "strict",
    default_visibility = ["//visibility:public"],
)

py_binary(
    name = "plot_rir",
    srcs = [
        "plot_rir.py",
    ],
    buildpar = 1,
    deps = [
        "//speech/dsp/room_acoustics_simulation:room_configuration_py_pb2",
        "//third_party/py/matplotlib",
    ],
)
