%This Matlab script can be used to reproduce Figure 5.19 in the textbook:
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

%Number of Monte Carlo realizations
realizations = 1000000;

%Number of antennas
M = 1;

%Set range of SNR values
SNRdB = -10:30;
SNR = db2pow(SNRdB);


%Capacity of non-fading channel
capacity_nonfading = log2(1+M*SNR);

%Prepare to save simulation results
capacity_Monte_Carlo = zeros(length(SNR),1);


%% Go through all number of antennas
for k = 1:length(SNR)
    
    %Generate random channel realizations
    h = (randn(M,realizations) + 1i*randn(M,realizations))/sqrt(2);
    
    %Compute ergodic capacity by Monte Carlo method
    gains = sum(abs(h).^2,1);
    
    %Estimate ergodic capacity
    capacity_Monte_Carlo(k) = mean(log2(1+SNR(k)*gains));

end


%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(SNRdB,capacity_nonfading,'k','LineWidth',2);
plot(SNRdB,capacity_Monte_Carlo,'r--','LineWidth',2);
xlabel('SNR [dB]','Interpreter','latex');
ylabel('Capacity [bit/symbol]','Interpreter','latex');
legend({'Non-fading','Rayleigh fading'},'Location','NorthWest','Interpreter','latex')
set(gca,'fontsize',16);
