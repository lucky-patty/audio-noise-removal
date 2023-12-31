%This was written by JB for jamdatajam on Youtube
%This script is for the walkthough video here:
%clear stuff
clear
clc
clf
%read in original sound file
[combined, Fs1] = audioread('EE-sound.wav'); %reads in sound file
[static, Fs2] = audioread('EE-sound-static.wav');
t = @(Fs, file) (1/Fs:1/Fs:length(file)/Fs); %sets the signal increments for plotting
%now decimate the signal to a lower sample rate
convert_combined = reshape(combined.',1,[]);
convert_static = reshape(static.',1,[]);
whos convert_combined
whos convert_static
combo_Lo_Fi = decimate(convert_combined, 4);
static_Lo_Fi = decimate(convert_static, 4);
%laplace of combo and static
L_combo = fft(combo_Lo_Fi);
L_static = fft(static_Lo_Fi);
%subtract fequencies out
L_clear = L_combo - L_static;
%L_clear = L_combo; % L_static;
%invese transform
clear_Lo_Fi = ifft(L_clear);
%plots
s = @(Fs) [1/Fs:Fs/length(combo_Lo_Fi)/2:Fs/2];
subplot (3,2,1)
plot(t(Fs1, combined), combined); %original signal
title('Original recoding (with noise)')
xlabel ('time (in seconds)')
ylabel ('amplitude')
subplot (3,2,2)
plot(t(Fs1/4, combo_Lo_Fi)-4.5, L_combo); %original in the frequency domain
axis([0 5 -100 100])
title('Original recoding (with noise)')
xlabel ('frequency')
ylabel ('amplitude')
subplot (3,2,4)
plot(t(Fs1/4, combo_Lo_Fi)-4.5, L_static); %static in frequency domain
axis([0 5 -100 100])
title('Background noise recording')
xlabel ('frequency')
ylabel ('amplitude')
subplot (3,2,6)
plot(t(Fs1/4, combo_Lo_Fi)-4.5, L_clear); %clear signal in frequency domain
axis([0 5 -100 100])
title('Recording after noise removal')
xlabel ('frequency')
ylabel ('amplitude')
subplot (3,2,3)
plot(t(Fs1/4, combo_Lo_Fi)-4.5, clear_Lo_Fi); %final signal in time domain
title('Recording after noise removal')
xlabel ('time (in seconds)')
ylabel ('amplitude')
%combine track of before and after, then play sound
mCompare = [combo_Lo_Fi; clear_Lo_Fi];
sound(mCompare, Fs1/4)

