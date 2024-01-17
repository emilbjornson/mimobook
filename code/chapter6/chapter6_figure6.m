%This Matlab script can be used to reproduce Figure 6.6 in the textbook:
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



%% Generate rate region with equal channel quality
SNR1 = 10;
SNR2 = 10;

%Rate with varying bandwidth
rate1 = B*xi1.*log2(1+SNR1./xi1);
rate2 = B*xi2.*log2(1+SNR2./xi2);

%Find sum-rate and max-min points
[sumrateValue1,indSR] = max(rate1+rate2);
[maxminValue1,indMMF] = max(min([rate1; rate2],[],1));



%Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex'); 

figure;
hold on; box on; grid on;
fill([0 rate1 0],[0 rate2 0],[252 243 161]/256);
plot(rate1,rate2,'k','LineWidth',2);
scatter(rate1(indSR),rate2(indSR),100,'rs','LineWidth',2)
scatter(rate1(indMMF),rate2(indMMF),100,'r*','LineWidth',2)
xlabel('$R_1$ [Mbit/s]','Interpreter','latex');
ylabel('$R_2$ [Mbit/s]','Interpreter','latex');
set(gca,'fontsize',13);
axis([0 40 0 40]);
xticks(0:5:40);
yticks(0:5:40);
axis square




%% Generate rate region with different channel quality
SNR1 = 10;
SNR2 = 5;

%Rate with varying bandwidth
rate1 = B*xi1.*log2(1+SNR1./xi1);
rate2 = B*xi2.*log2(1+SNR2./xi2);

%Find sum-rate and max-min points
[sumrateValue2,indSR] = max(rate1+rate2);
[maxminValue2,indMMF] = max(min([rate1; rate2],[],1));



%Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex'); 

figure;
hold on; box on; grid on;
fill([0 rate1 0],[0 rate2 0],[252 243 161]/256);
plot(rate1,rate2,'k','LineWidth',2);
scatter(rate1(indSR),rate2(indSR),100,'rs','LineWidth',2)
scatter(rate1(indMMF),rate2(indMMF),100,'r*','LineWidth',2)
xlabel('$R_1$ [Mbit/s]','Interpreter','latex');
ylabel('$R_2$ [Mbit/s]','Interpreter','latex');
set(gca,'fontsize',13);
axis([0 40 0 40]);
xticks(0:5:40);
yticks(0:5:40);
axis square

