%This Matlab script can be used to reproduce Figure 4.52 in the textbook:
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


%Set range of polarization parameter
kappa = [0 2*100/(1+100)^2 2*10/(1+10)^2];



capacity_MIMO_dualpolarization = zeros(length(SNR),length(kappa));


for k = 1:length(kappa)
    
    s1 = sqrt(1-kappa(k))+sqrt(kappa(k));
    s2 = sqrt(1-kappa(k))-sqrt(kappa(k));
    
    for p = 1:length(SNR)
        
        if SNR(p)<1/s2^2-1/s1^2
            q1normalized = 1;
            q2normalized = 0;
            
        else
            q1normalized = 1/2 + 1/(2*SNR(p)*s2^2) - 1/(2*SNR(p)*s1^2);
            q2normalized = 1/2 + 1/(2*SNR(p)*s1^2) - 1/(2*SNR(p)*s2^2);
            
        end
        
        capacity_MIMO_dualpolarization(p,k) = log2(1+q1normalized*SNR(p)*s1^2) + log2(1+q2normalized*SNR(p)*s2^2);
        
    end

end



%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex'); 

figure;
hold on; box on; grid on;
plot(SNRdB,capacity_MIMO_dualpolarization(:,1),'k','LineWidth',2);
plot(SNRdB,capacity_MIMO_dualpolarization(:,2),'r--','LineWidth',2);
plot(SNRdB,capacity_MIMO_dualpolarization(:,3),'b-.','LineWidth',2);
xlabel('SNR [dB]','Interpreter','latex');
ylabel('Capacity [bit/symbol]','Interpreter','latex');
legend({'$\kappa=0$','$\kappa \approx 0.02$ (XPD $=20\,$dB)','$\kappa \approx 0.17$ (XPD $=10\,$dB)'},'Interpreter','latex','Location','NorthWest');
set(gca,'fontsize',16);
