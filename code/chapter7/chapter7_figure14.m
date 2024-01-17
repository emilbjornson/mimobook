%This Matlab script can be used to reproduce Figure 7.14 in the textbook:
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
M = 5;

%Number of clusters
N_cl = [2 5];

%Number of RF inputs/outputs
N_RF = 2;

rate_hybrid = zeros(length(SNR),length(N_cl));
rate_digital = zeros(length(SNR),length(N_cl));


for n = 1:length(N_cl)

    rate_digital(:,n) = N_cl(n)*log2(1+SNR*M^2/N_cl(n)^2);
    rate_hybrid(:,n) = N_RF*log2(1+SNR*M^2/(N_cl(n)*N_RF));

end


%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex'); 

figure;
hold on; box on; grid on;
plot(SNRdB,rate_digital(:,2),'k','LineWidth',2);
plot(SNRdB,rate_hybrid(:,1),'b-.','LineWidth',2);
plot(SNRdB,rate_hybrid(:,2),'r--','LineWidth',2);
xlabel('SNR [dB]','Interpreter','latex');
ylabel('Capacity [bit/subcarrier symbol]','Interpreter','latex');
legend({'Digital: $N\!\mathrm{_{cl}}=5 $','Digital/hybrid: $N\!\mathrm{_{cl}}=2$','Hybrid: $N\!\mathrm{_{cl}}=5$'},'Interpreter','latex','Location','NorthWest');
set(gca,'fontsize',16);
