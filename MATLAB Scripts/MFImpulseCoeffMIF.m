% 
% MPImpulseCoeffMIF 
% ------------------------
% By: Augustas Jackevic
% For: University of Leeds
% Date: July 2021
%
% Short Description
% -----------------
% This script creates a MIF file containting the mathced filter impulse
% response coefficients. 10,000 coefficients are generated and loaded to
% the MIF file. The generating to the coefficients h_t is identical to the
% way its created in the script pulseCompressionFilter.m.
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
h_t = flip(conj(hilbert(chirpWave))) * 1000;


%%
% The following section is for the creation of the MIF file.

% Info about the MIF file.
MIFFile = 'MFImpulseCoeff.mif';

% Create or open (if file already exsists) the MIF file.
fileID = fopen(MIFFile,'w');


% Print the coefficients (h_t) to the MIF file. The values that are printed
% are the rounded real and imaginary parts.
for i = 1:1:length(h_t)
    fprintf(fileID,'%s\n', dec2bin(round(real(h_t(i))),16));
    fprintf(fileID,'%s\n', dec2bin(round(imag(h_t(i))),16));
end


% Close the opened MIF file.
fclose(fileID);
