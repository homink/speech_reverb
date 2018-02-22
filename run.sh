#!/usr/bin/bash
# set -e

stage=0

KALDI_ROOT=/home/kwon/3rdParty/kaldi
sampling_rate=16000
foreground_snrs="20:10:15:5:0"
background_snrs="20:10:15:5:0"
num_data_reps=3
db_string="'air' 'rwcp' 'rvb2014'" # RIR dbs to be used in the experiment
                                      # only dbs used for ASpIRE submission system have been used here
RIR_home=./RIR_databases # parent directory of the RIR databases files
RIR=./RIRS_NOISES
#base_rirs="simulated"
download_rirs=true # download the RIR databases from the urls or assume they are present in the RIR_home directory
input_wav=data/input_wav
output_wav=data/output_wav
impulses_noises=data/impulses_noises

. utils/parse_options.sh  # e.g. this parses the --stage option if supplied.

if [ $stage -le 0 ]; then
  utils/prepare_impulses_noises.sh --log-dir exp \
    --db-string "$db_string" \
    --download-rirs $download_rirs \
    --RIR-home $RIR_home \
    $impulses_noises || exit 1;
  echo "stage 0 done"
fi

if [ $stage -le 1 ]; then
  wget --no-check-certificate http://www.openslr.org/resources/28/rirs_noises.zip
  unzip rirs_noises.zip
  echo "stage 1 done"
fi

if [ $stage -le 2 ]; then
  mkdir -p $input_wav
  [ -f $input_wav/wav.scp ] && rm -f $input_wav/wav.scp
  [ -f $input_wav/reco2dur ] && rm -f $input_wav/reco2dur
  cat $1 | while read line;do
    fname=$(basename "$line")
    uid="${fname%.*}"
    echo $uid" "$line >> $input_wav/wav.scp
    samples=$(sox --i $line | grep Duration | sed 's/.*= \([0-9]\+\) .*/\1/')
    sample_rate=$(sox --i $line | grep "Sample Rate" | awk '{print $4}')
    duration=$(echo "$samples $sample_rate" | awk '{printf "%.4f \n", $1/$2}')
    echo $uid" "$duration >> $input_wav/reco2dur
  done
  echo "stage 2 done"
fi

if [ $stage -le 3 ]; then
  mkdir -p $output_wav
  export PATH=$KALDI_ROOT/src/featbin:$PATH
  rvb_opts=()

  if [ "$base_rirs" == "simulated" ]; then
    # This is the config for the system using simulated RIRs and point-source noises
    rvb_opts+=(--rir-set-parameters "0.5, $RIR/simulated_rirs/smallroom/rir_list")
    rvb_opts+=(--rir-set-parameters "0.5, $RIR/simulated_rirs/mediumroom/rir_list")
    rvb_opts+=(--noise-set-parameters $RIR/pointsource_noises/noise_list)
  else
    # This is the config for the JHU ASpIRE submission system
    rvb_opts+=(--rir-set-parameters "1.0, $RIR/real_rirs_isotropic_noises/rir_list")
    rvb_opts+=(--noise-set-parameters $RIR/real_rirs_isotropic_noises/noise_list)
  fi

  python utils/reverberate_data_dir.py \
    "${rvb_opts[@]}" \
    --prefix "rev" \
    --foreground-snrs $foreground_snrs \
    --background-snrs $background_snrs \
    --speech-rvb-probability 1 \
    --pointsource-noise-addition-probability 1 \
    --isotropic-noise-addition-probability 1 \
    --num-replications $num_data_reps \
    --max-noises-per-minute 1 \
    --source-sampling-rate 16000 \
    $input_wav $output_wav

  echo "stage 3 done"
fi
