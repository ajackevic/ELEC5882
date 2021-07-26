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
% response coefficients and its input data. 10,000 coefficients are generated 
% and loaded to the MIF file, whilst 66000 data input values are set through 
% for the input data. The generating to the coefficients h_t and the input signal
% receivedSignal is identical to the way its created in the script 
% pulseCompressionFilter.m. The values are muiltiplied by 1000 and rounded to make 
% them integers, thus suitable for FPGA. 2'scompliment binary values are set to the
% MIF files and are of bit width 16.
%
%

% Clear all of MATLAB's workspace variables.
clear all


% Setting the cirp waveform start and end frequency, as well as its
% duration and the sampling frequency.
chirpFreqStart = 1e6;   %1MHz
chirpFreqEnd = 10e6;    %10MHz
chirpDuration = 10e-6;  %10uS
samplingFreqs = 80e6;   %80MHz



%%
% Creating the matched filter impulse response signal, h_t.

% Sampling frequency of 100KHz for 0.1sec duration.
tChirp = 0:1/samplingFreqs:chirpDuration-1/samplingFreqs;

% Creating a linear chirp waveform with the set parameters.
chirpWave = chirp(tChirp,chirpFreqStart,chirpDuration,chirpFreqEnd);

% Impulse response of the matched filter. This is equal to the complex
% conjugate time reversal of the transmitted signal (chirpWave). The
% impulse reponse is muiltiplied by 1000 to aquire integers.
h_t = flip(conj(hilbert(chirpWave))) * 1451;




%%
% Creating the input signal, x_t.


% Creating padding of zeros before and after the chirp wave. These
% paddings are of duration equivalent to the length of chirpWave and consists of 
% amplitude reduction of 0.9, 0.8, 0.7, and 0.6.
paddedChirpWaveAmp1   = [zeros(1,length(chirpWave)), chirpWave * 1.0, zeros(1,length(chirpWave))];
paddedChirpWaveAmp0_9 = [zeros(1,length(chirpWave)), chirpWave * 0.9, zeros(1,length(chirpWave))];
paddedChirpWaveAmp0_8 = [zeros(1,length(chirpWave)), chirpWave * 0.8, zeros(1,length(chirpWave))];
paddedChirpWaveAmp0_7 = [zeros(1,length(chirpWave)), chirpWave * 0.7, zeros(1,length(chirpWave))];
paddedChirpWaveAmp0_6 = [zeros(1,length(chirpWave)), chirpWave * 0.6, zeros(1,length(chirpWave))];


% Creating chirp signals with different amount of noise.
chirp1 = awgn(paddedChirpWaveAmp1, 25);
chirp2 = awgn(paddedChirpWaveAmp0_9,15);
chirp3 = awgn(paddedChirpWaveAmp0_8,10);
chirp4 = awgn(paddedChirpWaveAmp0_7,5);
chirp5 = awgn(paddedChirpWaveAmp0_6,0.001);
chirp6 = awgn(paddedChirpWaveAmp1,-5);


% Summing up the different chirp waveforms into one continous long input signal.
receivedSignal = [chirp1, chirp2, chirp3, chirp4, chirp5, chirp6];
receivedSignal = receivedSignal * 204.7;






%%
% The following section is for the creation of the h_t MIF file.

% Name of the MIF file.
MIFFile = 'MFImpulseCoeff.mif';

% Create or open (if file already exsists) the MIF file.
fileID = fopen(MIFFile,'w');


% Print the coefficients (h_t) to the MIF file. The values that are printed
% are the rounded real and imaginary parts. They are printed in 2's
% compliment format. The length of each value is 16 bits.
for i = 1:1:length(h_t)
    binRealh_t = dec2bin(round(real(h_t(i))),16);
    binImagh_t = dec2bin(round(imag(h_t(i))),16);
    
    fprintf(fileID,'%s\n', binRealh_t(end-11:end));
    fprintf(fileID,'%s\n', binImagh_t(end-11:end));
end


% Close the opened MIF file.
fclose(fileID);






%%
% The following section is for the creation of the x_t MIF file.

% Name of the MIF file.
MIFFile = 'MFInputData.mif';

% Create or open (if file already exsists) the MIF file.
fileID = fopen(MIFFile,'w');


% Print the input data (x_t) to the MIF file. The values that are printed
% are the rounded to int values. They are printed in 2's
% compliment format. The length of each value is 16 bits.
for i = 1:1:length(receivedSignal)
    binReceivedSignal = dec2bin(round(receivedSignal(i)),16);
    
    fprintf(fileID,'%s\n', binReceivedSignal(end-11:end));
end


% Close the opened MIF file.
fclose(fileID);