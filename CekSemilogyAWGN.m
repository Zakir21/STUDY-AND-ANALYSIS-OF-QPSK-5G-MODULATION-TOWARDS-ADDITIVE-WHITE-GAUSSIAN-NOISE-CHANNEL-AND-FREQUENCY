clear all;
close all;
clc;

a = xlsread('Data.xlsx');
sumbu_y = a(6,:);
sumbu_x = a(1,:);

EbNo = -4 : 2 : 10; %dalam bentuk dB (AWGN)
for k = 1 : length(EbNo)
    mis = 0;
    M = 2; %jenis modulasi QPSK
    R = 1; %tanpa channel coding
    dn(k) = 10^(EbNo(k)/10); %mengubah dB ke numerik
    theoryBerAWGN(k) = 0.5*erfc(sqrt(dn(k)));
end

% ====================
%       Figure 
% ====================

figure;
semilogy(sumbu_x,sumbu_y, '^-');
% semilogy(sumbu_x,sumbu_y);

grid on;
legend ('BER Theory', '5G Simulation');
xlabel ('Eb/N0 (dB)');
ylabel ('Bit Error Rate (BER)');
title ('Bit error probability curve for QPSK modulation');

axis([-4 10 0.99e-5 1]);