%This Matlab script can be used to reproduce Figure 5.18 in the textbook:
%Emil Bjornson and Ozlem Tugfe Demir (2024),
%"Introduction to Multiple Antenna Communications and Reconfigurable Surfaces", 
%Boston-Delft: Now Publishers, http://dx.doi.org/10.1561/9781638283157
%
%This is version 1.0 (Last edited: 2024-01-17)
%
%License: This code is licensed under the GPLv2 license. If you in any way
%use this code for research that results in publications, please cite our
%textbook as described above. You can find the complete code package at
%https://github.com/emilbjornson/mimobook

close all;
clear;

%Number of Monte Carlo realizations (for multiplexing scheme)
realizations = 5000000;

%Number of antennas
M = 4;
K = 4;

%Rate requirement: 4 bit/symbol
R = 4;

%Set range of SNR values
SNRdB = 0:40;
SNR = db2pow(SNRdB);

%Prepare to save simulation results
Pout_MIMO_STBC = zeros(length(SNR),1);
Pout_MIMO_multiplexing = zeros(length(SNR),1);
Pout_MIMO_repetition = zeros(length(SNR),1);


%% Go through all SNR values
for n = 1:length(SNR)

    %Prepare to save the rates
    rates = zeros(realizations,1);

    for m = 1:realizations


        %Generate random channel realizations
        H = (randn(M,K) + 1i*randn(M,K))/sqrt(2);

        %Compute rate for the four streams with multiplexing, using SIC
        rateStreams = zeros(K,1);

        for k = 1:K

            %rateStreams(k) = real(log2(1+(SNR(n)/K)*H(:,k)'*((eye(M)+(SNR(n)/K)*H(:,k+1:end)*H(:,k+1:end)')\H(:,k))));
            rateStreams(k) = real(log2(det(eye(M)+(SNR(n)/K)*H(:,k:end)*H(:,k:end)')) - log2(det(eye(M)+(SNR(n)/K)*H(:,k+1:end)*H(:,k+1:end)')));

        end

        %The supported rate is the minimum of what the streams support
        rates(m) = K*min(rateStreams);

    end

    %Compute outage probability with the multiplexing scheme
    Pout_MIMO_multiplexing(n) = sum(R > rates)/realizations;

    %Compute outage probability with STBC and repetition scheme
    Pout_MIMO_STBC(n) = 1;
    Pout_MIMO_repetition(n) = 1;

    for m = 0:M*K-1
        Pout_MIMO_STBC(n)  = Pout_MIMO_STBC(n) - exp(-3*(2^(4*R/3)-1)/SNR(n)) * (3*(2^(4*R/3)-1)/SNR(n))^m / factorial(m);

        Pout_MIMO_repetition(n) = Pout_MIMO_repetition(n) - exp(-(2^(K*R)-1)/SNR(n)) * ((2^(K*R)-1)/SNR(n))^m / factorial(m);
    end

end


%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(SNRdB,Pout_MIMO_STBC(:,1),'b-.','LineWidth',2);
plot(SNRdB,Pout_MIMO_multiplexing(:,1),'r--','LineWidth',2);
plot(SNRdB,Pout_MIMO_repetition(:,1),'k:','LineWidth',2);
xlabel('SNR [dB]','Interpreter','latex');
ylabel('$P_{\textrm{out}}$','Interpreter','latex');
set(gca,'Yscale','log');
ylim([1e-4 1]);
legend({'STBC','Multiplexing','Repetition'},'Interpreter','latex','Location','SouthWest');
set(gca,'fontsize',16);
