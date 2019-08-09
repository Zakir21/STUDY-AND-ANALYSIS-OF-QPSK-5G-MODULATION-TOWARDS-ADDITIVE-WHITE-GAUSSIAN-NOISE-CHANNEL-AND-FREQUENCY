clear all;
close all;
clc;

a = xlsread('Data.xlsx');
sumbu_y = a(9,:);
sumbu_x = a(14,:);

EbNo = -4 : 2 : 50; %dalam bentuk dB (Fading)
for k = 1 : length(EbNo)
    mis = 0;
    M = 2; %jenis modulasi QPSK
    R = 1; %tanpa channel coding
    dn(k) = 10^(EbNo(k)/10); %mengubah dB ke numerik
    theoryBerFading(k) = 0.5*(1-(1/sqrt(1+(1/dn(k)))));
end

% ====================
%       Figure
% ====================

figure;
semilogy(EbNo,theoryBerFading,'--',sumbu_y,sumbu_x, '^-');

grid on;
legend ('BER Theory', '5G Simulation');
xlabel ('Eb/N0 (dB)');
ylabel ('Bit Error Rate (BER)');
title ('Bit error probability curve for QPSK modulation');

axis([-4 50 0.99e-5 1]);