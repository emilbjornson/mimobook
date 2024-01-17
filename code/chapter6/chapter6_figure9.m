%This Matlab script can be used to reproduce Figure 6.9 in the textbook:
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

%Bandwidth in MHz
B = 10;



%% Generate rate region with different channel quality
SNR1 = 10;
SNR2 = 5;

%Rates with orthogonal multiple access
rate1_OMA = B*xi1.*log2(1+SNR1./xi1);
rate2_OMA = B*xi2.*log2(1+SNR2./xi2);

%Rates with non-orthogonal multiple access
rate1_NOMA = [B*log2(1+SNR1) xi2*B*log2(1+SNR1)+xi1*B*log2(1+SNR1/(SNR2+1)) 0];
rate2_NOMA = [0 xi2*B*log2(1+SNR2/(SNR1+1))+xi1*B*log2(1+SNR2) B*log2(1+SNR2)];

%Find sum-rate and max-min points
[sumrateValue,indSR] = max(rate1_NOMA+rate2_NOMA);
[maxminValue,indMMF] = max(min([rate1_NOMA; rate2_NOMA],[],1));
[maxminValue_OMA,indMMF_OMA] = max(min([rate1_OMA; rate2_OMA],[],1));



%Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(rate1_NOMA,rate2_NOMA,'k','LineWidth',2);
plot(rate1_OMA,rate2_OMA,'k--','LineWidth',2);
fill([0 rate1_NOMA 0],[0 rate2_NOMA 0],[252 243 161]/256);
plot(rate1_NOMA,rate2_NOMA,'k','LineWidth',2);
plot(rate1_OMA,rate2_OMA,'k--','LineWidth',2);
plot(rate1_NOMA(2:end-1),rate2_NOMA(2:end-1),'r:','LineWidth',2)
scatter(rate1_NOMA(indMMF),rate2_NOMA(indMMF),100,'r*','LineWidth',2)
scatter(rate1_OMA(indMMF_OMA),rate2_OMA(indMMF_OMA),100,'r*','LineWidth',2)
xlabel('$R_1$ [Mbit/s]','Interpreter','latex');
ylabel('$R_2$ [Mbit/s]','Interpreter','latex');
set(gca,'fontsize',13);
axis([0 40 0 40]);
xticks(0:5:40);
legend({'NOMA','OMA (FDMA)'},'Interpreter','latex','Location','NorthEast');
axis square
