%This Matlab script can be used to reproduce Figure 5.22 in the textbook:
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

%Number of realizations of the Monte-Carlo Simulation
numberOfRealizations = 1000000;

%Set range of SNR values
SNRdB = -10:30;
SNR = db2pow(SNRdB);

%Number of antennas
K = 4;
M = 4;

%Generate channel realizations
H = (randn(M,K,numberOfRealizations)+1i*randn(M,K,numberOfRealizations))/sqrt(2);


%Prepare to store capacity values
capacity_SISO = zeros(length(SNR),1);
capacity_SIMO = zeros(length(SNR),1);
capacity_MISO = zeros(length(SNR),1);
capacity_MIMO = zeros(length(SNR),1);


%Go through all SNRs
for s = 1:length(SNR)
    
    %SISO capacity
    capacity_SISO(s) = mean(log2(1+SNR(s)*abs(H(1,1,:)).^2));
    
    %SIMO capacity
    capacity_SIMO(s) = mean(log2(1+SNR(s)*sum(abs(H(:,1,:)).^2,1)));
    
    %MISO capacity
    capacity_MISO(s) = mean(log2(1+(SNR(s)/K)*sum(abs(H(:,1,:)).^2,1)));
end

%MIMO capacity
for n = 1:numberOfRealizations
    
    HH = H(:,:,n)*H(:,:,n)';
    
    for s = 1:length(SNR)
        capacity_MIMO(s) = capacity_MIMO(s) + real(log2(det(eye(M)+(SNR(s)/K)*HH))/numberOfRealizations);
    end
    
end

%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex'); 

figure;
hold on; box on; grid on;
plot(SNRdB,capacity_MIMO,'k','LineWidth',2);
plot(SNRdB,capacity_SIMO,'r--','LineWidth',2);
plot(SNRdB,capacity_MISO,'k:','LineWidth',2);
plot(SNRdB,capacity_SISO,'b-.','LineWidth',2);
xlabel('SNR [dB]','Interpreter','latex');
ylabel('Ergodic capacity [bit/symbol]','Interpreter','latex');
ylim([0 40]);
legend({'MIMO: $M=K=4$','SIMO: $M=4$','MISO: $K=4$','SISO'},'Interpreter','latex','Location','NorthWest');
set(gca,'fontsize',16);
