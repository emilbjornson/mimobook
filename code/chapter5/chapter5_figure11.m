%This Matlab script can be used to reproduce Figure 5.11 in the textbook:
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
clear

%Set range of outage values
epsilon = 0:0.01:1;

%Set the average SNR
SNR = 1;

%Compute epsilon-outage capacity
C_epsilon = log2(1+SNR*log(1./(1-epsilon)));

%Compute capacity of AWGN channel
C_AWGN = log2(1+SNR);


%% Plot simulation result
set(groot,'defaultAxesTickLabelInterpreter','latex');  

figure;
hold on; box on; grid on;
plot(epsilon,C_epsilon,'k-','LineWidth',2);
plot(epsilon,C_AWGN*ones(size(C_epsilon)),'b-.','LineWidth',2);
xlabel('Outage probability: $\epsilon$','Interpreter','latex');
ylabel('$\epsilon$-outage capacity: $C_{\epsilon}$','Interpreter','latex');
legend({'Rayleigh fading','AWGN'},'Interpreter','latex','Location','NorthWest');
set(gca,'fontsize',16);