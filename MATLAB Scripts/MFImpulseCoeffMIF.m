% 
% MPImpulseCoeffMIF 
% ------------------------
% By: Augustas Jackevic
% For: University of Leeds
% Date: 
%
% Short Description
% -----------------
% 
%
%

% Clear all of MATLAB's workspace variables.
clear all


% Setting the cirp waveform start and end frequency, as well as its
% duration and the sampling frequency.
chirpFreqStart = 10000;
chirpFreqEnd = 50000;
chirpDuration = 0.1;
samplingFreqs = 1e5;

% Sampling frequency of 100KHz for 0.1sec duration.
tChirp = 0:1/samplingFreqs:chirpDuration-1/samplingFreqs;

% Creating a linear chirp waveform with the set parameters.
chirpWave = chirp(tChirp,chirpFreqStart,chirpDuration,chirpFreqEnd);

% Impulse response of the matched filter. This is equal to the complex
% conjugate time reversal of the transmitted signal (chirpWave).
h_t = flip(conj(hilbert(chirpWave)));


%%
%The following script section is for the creation of the MIf file.
