%% Step 1: Audio Frequency Analysis
% 1a: Read the audio file
[noisy_audio, frequency] = audioread('noisyaudio.wav');

% 1b: Compute and plot the DFT using built-in fft()
N = length(noisy_audio);
unfilter_dft = fft(noisy_audio);
f = (0:N-1)*(frequency/N);                 
magnitude = abs(unfilter_dft);
half_N = floor(N/2);

figure;
plot(f(1:half_N), magnitude(1:half_N));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('DFT of Noisy Audio');
xlim([0 frequency/2]);
grid on;

%% Step 2: Filter Design
% 2a: Decide digital passband and stopband edges
fp = 2000;
fs = 2500;
omega_p = 2*pi*fp/frequency;        % digital passband edge 
omega_s = 2*pi*fs/frequency;        % digital stopband edge 

% 2b: Compute minimum stop-band attenuation
idx_lo_p = find(f(1:half_N) <= fp,  1, 'last');
idx_hi_p = find(f(1:half_N) >= fp,  1, 'first');
Mp = (magnitude(idx_lo_p) + magnitude(idx_hi_p))/2;   % Average of 2 bins from both side of fp

idx_lo_s = find(f(1:half_N) <= fs, 1, 'last');
idx_hi_s = find(f(1:half_N) >= fs, 1, 'first');
Ms = (magnitude(idx_lo_s) + magnitude(idx_hi_s))/2;   % Average of 2 bins from both side of fs

As = -20*log10(Ms/Mp);

% 2c: Design an analog filter
T = 1/frequency;                   % Sampling period
analog_p = omega_p / T;            % Analog passband edge (rad/s)
analog_s = omega_s / T;            % Analog stopband edge (rad/s)
Ap = 1;                            % Passband ripple (dB)
kp = 10^(0.1*Ap) - 1;              % Passband ripple factor
ks = 10^(0.1*As) - 1;              % Stopband ripple factor

N_order = ceil(log(ks/kp) / (2*log(analog_s/analog_p)));   

Omega_cp = analog_p / (kp)^(1/(2*N_order));   % Passband-matched cutoff
Omega_cs = analog_s / (ks)^(1/(2*N_order));   % Stopband-matched cutoff
Omega_c = Omega_cs;

% 2d: Find the equivalent 𝜔𝑐 for the digital filter based on 2c above
omega_c = Omega_c * T;

% 2e: Plot the logarithmic gain of the frequency response
Omega = linspace(0, 2*Omega_c, 1000);   % Define analog frequency vector around cutoff
Ha = 20*log10(1 ./ sqrt(1 + (Omega/Omega_c).^(2 * N_order)));   % Compute magnitude response in dB

figure;
plot(Omega, Ha);
xlabel('Analog Frequency \Omega (rad/s)');
ylabel('Gain |H_a(j\Omega)| (dB)');
title('Logarithmic Gain of the frequency response');
grid on;

hold on;
xline(analog_p, '--r', '\Omega_p');
xline(analog_s, '--m', '\Omega_s');
yline(-Ap, '--b', 'Passband Ripple (-1 dB)');
yline(-As, '--k', sprintf('Stop-band Attenuation (%.2f dB)', As));
hold off;

%% Step 3: Filter Implementation
% 3a: Find the numerator and denominator polynomial coefficients
[b_z, a_z] = butter(N_order, omega_c/pi, 'low');

% 3b: Filter the noisy audio sample
filtered_audio = filter(b_z, a_z, noisy_audio);

% 3c: Calculate and plot the filtered audio sample
filtered_dft = fft(filtered_audio);
magnitude_f = abs(filtered_dft);

figure;
plot(f(1:half_N), magnitude_f(1:half_N));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('DFT of Filtered Audio');
xlim([0 frequency/2]);
grid on;

% 3d: Compare the unfiltered audio and filtered audio DFT plots.
figure;
plot(f(1:half_N), magnitude(1:half_N), 'b', 'DisplayName','Unfiltered');
hold on;
plot(f(1:half_N), magnitude_f(1:half_N), 'r', 'DisplayName','Filtered');
xlim([0 frequency/2]);
grid on;
title('Comparison of Unfiltered vs. Filtered Audio DFTs');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
legend;
hold off;

% 3e: Listen to the original audio and filtered audio
sound(noisy_audio, frequency);
pause(length(noisy_audio)/frequency + 1);
sound(filtered_audio, frequency);

% 3f: Write the filtered audio to file
audiowrite('filteredaudio.wav', filtered_audio, frequency);
