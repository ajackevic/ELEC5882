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
%The following section is for the creation of the MIF file.

% Info about the MIF file.
MIFFile = 'MFImpulseCoeff.mif';
depth = length(h_t) * 2;
width = 13;
MIFCounter = 0;

% Create or open (if file already exsists) the MIF file.
fileID = fopen(MIFFile,'w');

%Write the following info. This is the standard template of a MIF file.
fprintf(fileID,'WIDTH = %u;\n',width);
fprintf(fileID,'DEPTH = %u;\n\n',depth);

fprintf(fileID,'ADDRESS_RADIX = UNS;\n');
fprintf(fileID,'DATA_RADIX = DEC;\n\n');

fprintf(fileID,'CONTENT BEGIN\n');

for i = 1:1:length(h_t)
    fprintf(fileID,'        %u : %d;\n',MIFCounter,floor(round(real(h_t(i)))));
    fprintf(fileID,'        %u : %d;\n',MIFCounter+1,floor(round(imag(h_t(i)))));
    MIFCounter = MIFCounter + 2; 
end



% Close the opened MIF file.
fprintf(fileID,'END;\n');
fclose(fileID);
