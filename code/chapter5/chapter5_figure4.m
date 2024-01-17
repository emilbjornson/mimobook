%This Matlab script can be used to reproduce Figure 5.4 in the textbook:
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

%Variance of the Gaussian distribution
beta = 1;


%Compute exact CDF for Rayleigh distribution 
x = 0:0.01:3;
CDF = 1 - exp(-x.^2/beta);


%Number of realizations of the Monte-Carlo Simulation
numberOfRealizations = 1000000;


%Number of paths
L = [2 5];

%Generate Monte-Carlo realization to create an empirical CDF

phases = 2*pi*rand(max(L),numberOfRealizations);
magnitudesSorted = zeros(numberOfRealizations,length(L));

for l = 1:length(L)
    magnitudesSorted(:,l) = sort(abs(sum(exp(1j*phases(1:L(l),:)),1)),'ascend')/sqrt(L(l));
end

CDFvalues = linspace(0,1,numberOfRealizations);


%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(magnitudesSorted(:,1),CDFvalues,'--k','LineWidth',2)
plot(magnitudesSorted(:,2),CDFvalues,'-.r','LineWidth',2)
plot(x,CDF,'-b','LineWidth',2)
xlabel('$x$','Interpreter','latex');
ylabel('Cumulative distribution function','Interpreter','latex');
set(gca,'fontsize',16);
legend({'$L=2$', '$L=5$','Rayleigh fading'},'Location','SouthEast','Interpreter','latex');
