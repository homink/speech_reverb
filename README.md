# speech_reverb
This repository includes scripts for reverberation WAV file creation.

You can play back by clicking the following WAV file names.

| [fv01_t01_s01.wav](https://soundcloud.com/user-623907374/fv01-t01-s01) | [rev1_fv01_t01_s01.wav](https://soundcloud.com/user-623907374/rev1-fv01-t01-s01) |
:-------------------------:|:-------------------------:
![alt text](https://github.com/homink/speech_reverb/blob/master/fv01_t01_s01.PNG) | ![alt text](https://github.com/homink/speech_reverb/blob/master/rev1_fv01_t01_s01.PNG)
| [rev2_fv01_t01_s01.wav](https://soundcloud.com/user-623907374/rev2-fv01-t01-s01) | [rev3_fv01_t01_s01.wav](https://soundcloud.com/user-623907374/rev3-fv01-t01-s01)
![alt text](https://github.com/homink/speech_reverb/blob/master/rev2_fv01_t01_s01.PNG) | ![alt text](https://github.com/homink/speech_reverb/blob/master/rev3_fv01_t01_s01.PNG)

## Dependency

[kaldi](https://github.com/kaldi-asr/kaldi)

Only [wav-reverberate](https://github.com/kaldi-asr/kaldi/blob/master/src/featbin/wav-reverberate.cc) is used here but several kaldi utils are running in back-end. Future work would be bailing out necessary parts.

## Command
```
./run.sh <input file including WAV file paths per line>
```

For example,
```
head wavfilst.lst

/home/kwon/copora/NIKL_trim_head100ms/fv01/fv01_t01_s01.wav
/home/kwon/copora/NIKL_trim_head100ms/fv01/fv01_t01_s02.wav
/home/kwon/copora/NIKL_trim_head100ms/fv01/fv01_t01_s03.wav
/home/kwon/copora/NIKL_trim_head100ms/fv01/fv01_t01_s04.wav
/home/kwon/copora/NIKL_trim_head100ms/fv01/fv01_t01_s05.wav
/home/kwon/copora/NIKL_trim_head100ms/fv01/fv01_t01_s06.wav
/home/kwon/copora/NIKL_trim_head100ms/fv01/fv01_t01_s07.wav
/home/kwon/copora/NIKL_trim_head100ms/fv01/fv01_t01_s08.wav
/home/kwon/copora/NIKL_trim_head100ms/fv01/fv01_t01_s09.wav
/home/kwon/copora/NIKL_trim_head100ms/fv01/fv01_t01_s10.wav

./run.sh wavfile.lst

ls data/output_wav/ -1

rev1_fv01_t01_s01.wav
rev1_fv01_t01_s02.wav
rev1_fv01_t01_s03.wav
rev1_fv01_t01_s04.wav
rev1_fv01_t01_s05.wav
rev1_fv01_t01_s06.wav
rev1_fv01_t01_s07.wav
rev1_fv01_t01_s08.wav
rev1_fv01_t01_s09.wav
rev1_fv01_t01_s10.wav
rev2_fv01_t01_s01.wav
rev2_fv01_t01_s02.wav
rev2_fv01_t01_s03.wav
rev2_fv01_t01_s04.wav
rev2_fv01_t01_s05.wav
rev2_fv01_t01_s06.wav
rev2_fv01_t01_s07.wav
rev2_fv01_t01_s08.wav
rev2_fv01_t01_s09.wav
rev2_fv01_t01_s10.wav
rev3_fv01_t01_s01.wav
rev3_fv01_t01_s02.wav
rev3_fv01_t01_s03.wav
rev3_fv01_t01_s04.wav
rev3_fv01_t01_s05.wav
rev3_fv01_t01_s06.wav
rev3_fv01_t01_s07.wav
rev3_fv01_t01_s08.wav
rev3_fv01_t01_s09.wav
rev3_fv01_t01_s10.wav
```

## Configuration

run.sh includes several variables to control reverberation WAV file creation. Here is a few information

* num_data_reps : the number of reverberation wav files for creation
* foreground/background_snrs : signal-to-noise ratios when additive noise is applied
* db_string : RIR (Room Impulse Response) databases used for the reverberation wav file creation
              You may want to try aalto, c4dm, mardy and varechoic which are not tested yet.
              
* base_rirs="simulated" :simulated RIRs are applied, otherwise real isotropic RIR is applied

## Miscellaneous

[kaldi](https://github.com/kaldi-asr/kaldi) has made use of [reverberate_data_dir.py](https://github.com/kaldi-asr/kaldi/blob/master/egs/wsj/s5/steps/data/reverberate_data_dir.py) to be working for pre-trained phone moldes where phone alignments are obtained from clean speech. [run.sh](https://github.com/homink/speech_reverb/blob/master/run.sh) follows [wav.scp](http://kaldi-asr.org/doc/data_prep.html) structure and [utils/reverberate_data_dir.py](https://github.com/homink/speech_reverb/blob/master/utils/reverberate_data_dir.py) is modified to create reverberation WAV files.
