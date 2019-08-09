close all;
clear all;
clc;

ebno = 10; %dalam bentuk dB ===== AWGN
trial = 1000; %percobaan ==== AWGN

for k = 1 : length(ebno)
    mis = 0;
    M = 2; %jenis modulasi QPSK
    R = 1; %tanpa channel coding
    dn(k) = 10^(ebno(k)/10); %mengubah dB ke numerik
    SNR(k) = M * R * dn(k); %numerik
    for tr = 1 : trial
%       bi = randi([0 1],1,1000);
        bi = [1 1];
        n=2; %banyaknya data yang akan diambil dari sinyal /2bit dalam QPSK
        u=1; %counter / pergeseran data
        % membaca nilai sinyal input, membagi biner menjadi 2 biner / simbol
        for i=1:(length(bi)/n)
            b(i,:)= bi(u:u+(n-1));
            u=u+n;
        end
        % =============================================
        % Melakukan perhitungan QPSK 5G 3GPP (MODULASI)
        % =============================================
        for c = 1:(length(bi)/n);
            hasil(c) = (1/sqrt(2))*((1-2*(b(c,1)))+sqrt(-1)*(1-2*(b(c,2))));
        end
        
        % ==================
        %       AWGN
        % ==================
        sigma = sqrt(1/SNR(k));
        noise = (randn(1,length(hasil))+(randn(1,length(hasil))*sqrt(-1)))*((sigma)/sqrt(2)); %noise
        h = 1; %Kanal AWGN
        %Rx (penerima)
        rx= h*hasil+noise;
        y = conj(h)*rx/(h*conj(h)+sigma^2); %equalizer
        
        % ===================
        % Pemetaan Demodulasi
        % ===================
        for j=1:length(y)
            if (real (y(1,j)) > 0 && imag (y(1,j)) > 0);
                d(j) = 0.7071+0.7071i;
            elseif (real (y(1,j)) < 0 && imag (y(1,j)) > 0);
                d(j) = -0.7071+0.7071i;
            elseif (real (y(1,j)) < 0 && imag (y(1,j)) < 0);
                d(j) = -0.7071-0.7071i;
            else (real (y(1,j)) > 0 && imag (y(1,j)) < 0);
                d(j) = 0.7071-0.7071i;
            end
        end
        
        % =====================================================
        % Mengubah nilai hasil demodulasi kedalam bentuk binner
        % =====================================================
        for j=1:length(d)
            if (d(1,j) == 0.7071+0.7071i);
                s{j}=[0 0];
            elseif (d(1,j) == -0.7071+0.7071i);
                s{j}=[1 0];
            elseif (d(1,j) == -0.7071-0.7071i);
                s{j}=[1 1];
            else (d(1,j) == 0.7071-0.7071i);
                s{j}=[0 1];
            end
        end
        
        % ===================================================
        % Membuat 1 baris binner dari hasil pengubahan diatas
        % ===================================================
        bn = cell2mat(s);
        
        % ===================
        %  Mencari nilai BER
        % ===================
        for i=1:length(bn)
            if bi(i)~=bn(i)
                mis=mis+1;
            end
        end
    end
    disp(ebno(k));
    theoryBerAWGN(k) = 0.5*erfc(sqrt(dn(k)));
 mis
    BER(k)=mis/(length(bi)*trial);
end

% ====================
% Plotting scatterplot
% ====================
figure;
semilogy(ebno,theoryBerAWGN, '-.', ebno,BER, '^-'); %AWGN

grid on;
legend ('BER Theory', '5G Simulation');
xlabel ('Eb/N0 (dB)');
ylabel ('Bit Error Rate(BER) AWGN');
title ('Bit error probability curve for QPSK modulation');

axis([0 10 0.99e-5 1]); %AWGN
% axis([0 30 0.99e-5 1]); %Fading