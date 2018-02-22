#!/bin/bash

# Copyright 2014  Johns Hopkins University (Author: Vijayaditya Peddinti)
#           2015  Tom Ko
# Apache 2.0.
# This script processes generates multi-condition training data from clean data dir
# and directory with impulse responses and noises

set -e

random_seed=0
snrs="20:10:15:5:0"
log_dir=exp/make_reverb

. ./utils/parse_options.sh

if [ $# != 3 ]; then
  echo "Usage: reverberate_data_dir_speed.sh [options] <src_dir> <impulse-noise-dir> <dest_dir>"
  echo "e.g.:"
  echo " $0 --random-seed 12 data/train_si284 data_multicondition/impulses_noises data/train_si284p"
  exit 1;
fi

src_dir=$1
impnoise_dir=$2
dest_dir=$3

mkdir -p $dest_dir
mkdir -p $log_dir

wav_prefix="rev${random_seed}_"

# create the wav.scp files
cat $src_dir/wav.scp | sed -e "s/^\s*//g" | \
  cut -d' ' -f1 | \
  awk -v p2=$wav_prefix \
  '{printf("%s%s\n", p2, $1);}'> $log_dir/corrupted_${random_seed}.list

python utils/reverberate_wavs.py \
  --snrs $snrs --random-seed $random_seed \
  $src_dir/wav.scp $log_dir/corrupted_${random_seed}.list $impnoise_dir \
  $dest_dir/wav.scp || exit 1;

echo "Successfully generated corrupted data and stored it in $dest_dir." && exit 0;
