% This script shows the general concept of a matched filter. Observe the
% different plots to see the required signals at different stages of the
% system.


% Sample the chirp signal at 10KHz for 1 second.
t = 0:1/1e4:1;
% Create a chirp signal going from 100Hz to 1KHz in a 1 sec duration.
onlyChirpWave = chirp(t,100,1,1e3);
% Creating a zero vector of 10000 values which is then padded on either
% side of the chirp waveform.
zeroVector = zeros(1,10000);
chirpWave = [zeroVector onlyChirpWave zeroVector];
% Adding a white gaussian noise of 2dB SNR to the chirp waveform.
s_t_period = awgn(chirpWave, 2);
% Repeating the noisy chirp waveform 5 times.
s_t = [s_t_period s_t_period s_t_period s_t_period s_t_period];

% The Matched Filter impulse response requires the time-reversed chirp
% signal. This would be the FIR coefficients.
h_t = flip(onlyChirpWave);

% This is the filtering stage between the noisy input signal (s_t) and the
% impulse response of the filter (h_t). Y_t is the output of the matched
% filter.
y_t = filter(h_t,1,s_t);


% The plotting of 5 waveforms.
figure(1)
plot(chirpWave)
title("Chirp waveform 100Hz to 1KHz")

figure(2)
plot(s_t_period)
title("The chirp waveform with the addition of noise")

figure(3)
plot(s_t)
title("Input signal to the Mathced Filter")

figure(4)
plot(h_t)
title("Matched filter impulse response signal")

figure(5)
plot(y_t)
title("Matched filter output")
