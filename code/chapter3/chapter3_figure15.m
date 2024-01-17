%This Matlab script can be used to reproduce Figure 3.15 in the textbook:
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


%Set range of SNR values
SNRdB = -10:30;
SNR = db2pow(SNRdB);

%Number of antennas
M = 4;

%SISO case
capacity_SISO = log2(1+SNR);

%SIMO and MISO case
capacity_SIMO = log2(1+SNR*M);

%MIMO case
capacity_MIMO = M*log2(1+SNR);


%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex'); 

figure;
hold on; box on; grid on;
plot(SNRdB,capacity_MIMO,'k','LineWidth',2);
plot(SNRdB,capacity_SIMO,'r--','LineWidth',2);
plot(SNRdB,capacity_SISO,'b-.','LineWidth',2);
xlabel('SNR [dB]','Interpreter','latex');
ylabel('Capacity [bit/symbol]','Interpreter','latex');
legend({'MIMO: $M=K=4$','SIMO/MISO: $M=4$','SISO'},'Interpreter','latex','Location','NorthWest');
set(gca,'fontsize',16);
