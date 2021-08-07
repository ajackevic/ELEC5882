% idealPulseCompressionFilter.m
% --------------
% By: Augustas Jackevic
% Date: April 2021

% Script Description:
% -------------------
% This script shows the general concept of a pulse compression filter.
% Observe the different plots to see the required signals at different
% stages of the system.



% Clear any saved variable from MATLAB's workspace section.
clear all





chirpFreqStart = 1e6;   %1MHz
chirpFreqEnd = 10e6;    %10MHz
chirpDuration = 10e-6;  %10uS
samplingFreqs = 80e6;   %80MHz


% Sampling frequency of samplingFreqs for chirpDuration duration.
tChirp = 0:1/samplingFreqs:chirpDuration-1/samplingFreqs;
% Creating the time scale for x_t, this is used when plotting the graph.
tInput = 0:1/samplingFreqs:(chirpDuration * 18) -1/samplingFreqs;
% Creating the time scale for y_t.
tOut = 0:1/samplingFreqs:(chirpDuration * 19) -1/samplingFreqs;


% Creating a linear chirp waveform
chirpWave = chirp(tChirp,chirpFreqStart,chirpDuration,chirpFreqEnd);


% Creating padding of zeros before and after the chirp wave. These
% paddings are of 0.1 sec duration and consists of amplitude reduction of 0.9,
% 0.8, 0.7, and 0.6.
paddedChirpWaveAmp1   = [zeros(1,length(chirpWave)), chirpWave * 1.0, zeros(1,length(chirpWave))];
paddedChirpWaveAmp0_9 = [zeros(1,length(chirpWave)), chirpWave * 0.9, zeros(1,length(chirpWave))];
paddedChirpWaveAmp0_8 = [zeros(1,length(chirpWave)), chirpWave * 0.8, zeros(1,length(chirpWave))];
paddedChirpWaveAmp0_7 = [zeros(1,length(chirpWave)), chirpWave * 0.7, zeros(1,length(chirpWave))];
paddedChirpWaveAmp0_6 = [zeros(1,length(chirpWave)), chirpWave * 0.6, zeros(1,length(chirpWave))];


% Creating chirp signals with different amount of noise.
chirp1 = paddedChirpWaveAmp1;
chirp2 = awgn(paddedChirpWaveAmp0_9,15,1,1);
chirp3 = awgn(paddedChirpWaveAmp0_8,10,1,1);
chirp4 = awgn(paddedChirpWaveAmp0_7,5,1,1);
chirp5 = awgn(paddedChirpWaveAmp0_6,0.001,1,1);
chirp6 = awgn(paddedChirpWaveAmp1,-5,1,1);


% Summing up the different chirp waveforms into one continuous long input signal.
receivedSignalNoNoise = [paddedChirpWaveAmp1, paddedChirpWaveAmp0_9, paddedChirpWaveAmp0_8, ...
                         paddedChirpWaveAmp0_7, paddedChirpWaveAmp0_6, paddedChirpWaveAmp1];
receivedSignal = [chirp1, chirp2, chirp3, chirp4, chirp5, chirp6];

% Creating the matched filter impulse response. This is equal to the complex
% conjugate time reverse analytic signal of the chirp signal.
h_t = flip(conj(hilbert(chirpWave)));
% Creating an analytic signal from the input signal.
x_t = hilbert(receivedSignal);


% The matched filter operation is a convolution between the input signal
% and the matched filters impulse response.
matchedFilterOut = conv(x_t,h_t);


% Obtaining the envelop value of the matched filter output.
y_t = abs(matchedFilterOut);



%%
% Plot graphs



% Plotting the following graphs:
%    Chirp waveform
%    Received echoed back signal with no noise
%    Received echoed back signal with noise

figure(1)
tiledlayout(3,1);

nexttile
plot(tChirp,chirpWave)
title('Liniear Chirp Waveform from 10KHz to 50KHz')
ylabel('Amplitude')
xlabel('Time (S)')
xlim([0 0.5])
ylim([-1.2 1.2])

nexttile
plot(tInput,receivedSignalNoNoise)
title('Echoed back signal from the receiver with no noise')
ylabel('Amplitude')
xlabel('Time (S)')
xlim([0 9])
ylim([-1.2 1.2])

nexttile
plot(tInput,receivedSignal)
title('Echoed back signal from the receiver with noise')
ylabel('Amplitude')
xlabel('Time (S)')
xlim([0 9])
ylim([-10 10])

% Plotting the following graphs:
%    Real part of the received after the hilbert transform
%    Imaginary part of the received after the hilbert transform
%    Real part of the matched filter impulse response after the hilbert transform
%    Imaginary part of the matched filter impulse response after the hilbert transform
%    Matched filter output waveform

figure(2)
tiledlayout(3,2);

nexttile
plot(tInput,real(x_t))
title('Real part of the received signal XRe(t)')
ylabel('Amplitude')
xlabel('Time (S)')
xlim([0 9])
ylim([-10 10])

nexttile
plot(tInput,imag(x_t))
title('Imaginary part of the received signal XIm(t)')
ylabel('Amplitude')
xlabel('Time (S)')
xlim([0 9])
ylim([-10 10])

nexttile
plot(tChirp,real(h_t))
title('Real part of the impulse response hRe(t)')
ylabel('Amplitude')
xlabel('Time (S)')


nexttile
plot(tChirp,imag(h_t))
title('Imaginary part of the received signal hIm(t)')
ylabel('Amplitude')
xlabel('Time (S)')


nexttile([1 2])
plot(tOut(1:end-1),y_t)
title('Matched filter output y(t)')
ylabel('Magnitude (dB)')
xlabel('Time (S)')
