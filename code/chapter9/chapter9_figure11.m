%This Matlab script can be used to reproduce Figure 9.11 in the textbook:
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

%Define the individual channel gains
beta_t = db2pow(-80);
beta_r = db2pow(-60);
beta_s1 = db2pow(-80);
beta_s2 = db2pow(-110);


%Range of atoms
N = 0:1000;

%Define the transmit SNR
PBN0 = db2pow(100);


%Compute the end-to-end channel gain for the two cases
channelgain1 = (sqrt(beta_s1)+N*sqrt(beta_t*beta_r)).^2;
channelgain2 = (sqrt(beta_s2)+N*sqrt(beta_t*beta_r)).^2;



%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(N,log2(1+PBN0*channelgain1),'r-','LineWidth',2)
plot(N,log2(1+PBN0*channelgain2),'b-.','LineWidth',2)
xlabel('Number of metaatoms ($N$)','Interpreter','latex');
ylabel('Capacity [bit/symbol]','Interpreter','latex');
legend({'$\beta_{\textrm{s}}=-80$\,dB','$\beta_{\textrm{s}}=-110$\,dB'},'Interpreter','latex','Location','NorthWest','Location','SouthEast');
set(gca,'fontsize',16);
