%This Matlab script can be used to reproduce Figure 5.12 in the textbook:
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

%Set SNR range
SNRdB = 0:50;
SNR = 10.^(SNRdB/10);

%Set range of epsilon values
epsilonRange = [0.1 0.01];


%Compute epsilon-outage capacity for different values of epsilon
C_epsilon = zeros(length(SNR),length(epsilonRange));

for n = 1:length(epsilonRange)
    
    C_epsilon(:,n) = log2(1+SNR*log(1./(1-epsilonRange(n))));
    
end

%Compute capacity of AWGN channel
C_AWGN = log2(1+SNR');



%% Plot simulation result
set(groot,'defaultAxesTickLabelInterpreter','latex');  

figure;
hold on; box on; grid on;
plot(SNRdB,C_epsilon(:,1)./C_AWGN,'k-','LineWidth',2);
plot(SNRdB,C_epsilon(:,2)./C_AWGN,'b--','LineWidth',2);
xlabel('SNR [dB]','Interpreter','latex');
ylabel('Fraction of AWGN capacity','Interpreter','latex');
legend({'$\epsilon=0.1$','$\epsilon=0.01$'},'Interpreter','latex','Location','NorthWest');
ylim([0 1]);
set(gca,'fontsize',16);

