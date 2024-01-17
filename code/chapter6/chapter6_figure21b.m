%This Matlab script can be used to reproduce Figure 6.21(b) in the textbook:
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

%Select the range of xi-values (start at a small non-zero value to avoid
%division by zero).
eps = 1e-8;
xi1 = linspace(eps,1-eps,1000);
xi2 = 1 - xi1;

%Select the range of power division values
powerFraction1 = linspace(0,1,1000);
powerFraction2 = 1-powerFraction1;


%Bandwidth in MHz
B = 10;


%% Generate rate region with different channel quality (the *2 for the DL is used to define the SNR values for equal power allocation)
SNR1_UL = 10;
SNR2_UL = 5;
SNR1_DL = SNR1_UL*2;
SNR2_DL = SNR2_UL*2;


%Rates with non-orthogonal multiple access in uplink 
rate1_NOMA_UL = [B*log2(1+SNR1_UL) xi2*B*log2(1+SNR1_UL)+xi1*B*log2(1+SNR1_UL/(SNR2_UL+1)) 0];
rate2_NOMA_UL = [0 xi2*B*log2(1+SNR2_UL/(SNR1_UL+1))+xi1*B*log2(1+SNR2_UL) B*log2(1+SNR2_UL)];


%Rates with non-orthogonal multiple access in downlink 
rate1_NOMA_DL = B*log2(1+SNR1_DL*powerFraction1);
rate2_NOMA_DL = B*log2(1+SNR2_DL*powerFraction2./(1+SNR2_DL*powerFraction1));


%Find sum-rate and max-min points
[~,indSR_DL] = max(rate1_NOMA_DL+rate2_NOMA_DL);
[~,indMMF_DL] = max(min([rate1_NOMA_DL; rate2_NOMA_DL],[],1));
[~,indMMF_UL] = max(min([rate1_NOMA_UL; rate2_NOMA_UL],[],1));


%Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(rate1_NOMA_DL,rate2_NOMA_DL,'k','LineWidth',2);
plot(rate1_NOMA_UL,rate2_NOMA_UL,'k--','LineWidth',2);
fill([0 rate1_NOMA_DL 0],[0 rate2_NOMA_DL 0],[252 243 161]/256);
plot(rate1_NOMA_UL,rate2_NOMA_UL,'k--','LineWidth',2);
plot(rate1_NOMA_UL(2:end-1),rate2_NOMA_UL(2:end-1),'r:','LineWidth',2)
scatter(rate1_NOMA_UL(indMMF_UL),rate2_NOMA_UL(indMMF_UL),100,'r*','LineWidth',2)
scatter(rate1_NOMA_DL(indMMF_DL),rate2_NOMA_DL(indMMF_DL),100,'r*','LineWidth',2)
scatter(rate1_NOMA_DL(indSR_DL),rate2_NOMA_DL(indSR_DL),100,'rs','LineWidth',2)
xlabel('$R_1$ [Mbit/s]','Interpreter','latex');
ylabel('$R_2$ [Mbit/s]','Interpreter','latex');
set(gca,'fontsize',13);
axis([0 50 0 50]);
xticks(0:5:50);
yticks(0:5:50);
axis square
legend({'NOMA (Downlink)','NOMA (Uplink)'},'Interpreter','latex','Location','NorthEast');
