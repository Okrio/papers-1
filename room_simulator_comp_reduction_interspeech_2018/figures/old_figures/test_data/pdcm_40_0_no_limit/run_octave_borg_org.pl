#!/usr/bin/perl
# Usual usage:
#
# First run copy_matlab_lib_here.pl. TODO(chanwcom)
use strict;
use warnings;

use octave_util::octave_borg_util qw(RunOctaveOnBorg);

my $octave_command
    = "main_process_4mic('_SOURCE_FEATURE_FILE_', '_DEST_FEATURE_FILE_')\;";
my $in_sstable = "/namespace/speech-team/ic-d/thadh/rerecorded/keyed_properly/2014.03.14_DH20120424_CH0_adapt1/iO4_85cm.sstable-00000-of-00001";
my $out_sstable = "/namespace/speech-team/ic-d/chanwcom/work/pdcm_2_mic_256_10_freq_offset_re/2014.03.14_DH20120424_CH0_adapt1/output_iO4_85cm.sstable-00000-of-00001\@1";
my $cell = "yh";
my @octave_code_path = (".");

RunOctaveOnBorg(
    $octave_command,
    $in_sstable,
    $out_sstable,
    $cell,
    @octave_code_path);

my $in_sstable = "/cns/ic-d/home/speech-team/rs=6.3/thadh/rerecorded/2014.03.18_test201307_nissan_altima/iO4_74cm_driver_dashboard.sstable-00000-of-00001";
my $out_sstable = "/namespace/speech-team/ic-d/chanwcom/work/pdcm_2_mic_256_10_freq_offset_re/2014.03.18_test201307_nissan_altima/output_iO4_74cm_driver_dashboard.sstable-00000-of-00001\@1";

RunOctaveOnBorg(
    $octave_command,
    $in_sstable,
    $out_sstable,
    $cell,
    @octave_code_path);
