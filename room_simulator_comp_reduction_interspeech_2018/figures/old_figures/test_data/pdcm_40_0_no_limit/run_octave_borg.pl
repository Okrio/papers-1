#!/usr/bin/perl
# Usual usage:
#
# First run copy_matlab_lib_here.pl. TODO(chanwcom)
use strict;
use warnings;

use octave_util::octave_borg_util qw(RunOctaveOnBorg);

my $octave_command
    = "main_process('_SOURCE_FEATURE_FILE_', '_DEST_FEATURE_FILE_', 40, 0)\;";
my $in_sstable = "/namespace/speech-team/ic-d/chanwcom/speech_database/rerecorded_database/iO4_85cm.random100.sstable-00000-of-00001";
my $out_sstable = "/namespace/speech-team/ic-d/chanwcom/work/pdcm_experiments_june_2014/etsi_40_0_no_limit/output_iO4_85cm.sstable-00000-of-00001\@1";
my $cell = "yh";
my @octave_code_path = (".");

RunOctaveOnBorg(
    $octave_command,
    $in_sstable,
    $out_sstable,
    $cell,
    @octave_code_path);

my $in_sstable = "/namespace/speech-team/ic-d/chanwcom/speech_database/rerecorded_database/iO4_74cm_driver_dashboard.random100.sstable-00000-of-00001";
my $out_sstable = "/namespace/speech-team/ic-d/chanwcom/work/pdcm_experiments_june_2014/car_40_0_no_limit/output_iO4_74cm_driver_dashboard.sstable-00000-of-00001\@1";

RunOctaveOnBorg(
    $octave_command,
    $in_sstable,
    $out_sstable,
    $cell,
    @octave_code_path);
