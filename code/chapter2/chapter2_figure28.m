%This Matlab script can be used to reproduce Figure 2.28 in the textbook:
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

DClevel1 = 0;
DClevel2 = 1;


PFA = 10.^(-[1, 3, 5]);
threshold = norminv(1-PFA);
SNR = 0:0.01:20; 
sigma = sqrt(1./db2pow(SNR));

qfunc = @(x) 0.5 * erfc(x/sqrt(2));

PD = zeros(length(sigma),length(threshold));

for s = 1:length(sigma)
    for t = 1:length(threshold)
        
        PD(s,t) = qfunc(threshold(t)-1/sigma(s));
    end
end



%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');
figure;
hold on; box on;
plot(SNR,PD(:,1),'k','LineWidth',2)
plot(SNR,PD(:,2),'r--','LineWidth',2)
plot(SNR,PD(:,3),'b-.','LineWidth',2)


ylim([0 1]);
xlabel('SNR [dB]','Interpreter','latex');
ylabel('Probability of detection','Interpreter','latex');
legend({'$P_{\rm FA}=10^{-1}$', '$P_{\rm FA}=10^{-3}$', '$P_{\rm FA}=10^{-5}$'},'Interpreter','latex','Location', 'southeast');
set(gca,'fontsize',16);
grid on
