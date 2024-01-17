%This Matlab script can be used to reproduce Figure 6.1 in the textbook:
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

%Number of realizations of the Monte-Carlo Simulation
numberOfRealizations = 1000000;

%Set range of SNR values
SNRdB = -10:30;
SNR = db2pow(SNRdB);

%Number of antennas
M = 4;

%Generate channel realizations
H = (randn(M,M,numberOfRealizations)+1i*randn(M,M,numberOfRealizations))/sqrt(2);

%SISO in LOS
capacity_SISO_LOS = log2(1+SNR);

%MIMO in LOS
capacity_MIMO_LOS = log2(1+SNR*M^2);


%Prepare to store capacity values
capacity_MIMO_NLOS = zeros(length(SNR),1);



%MIMO capacity
for n = 1:numberOfRealizations
    
    HH = H(:,:,n)*H(:,:,n)';
    
    for s = 1:length(SNR)
        capacity_MIMO_NLOS(s) = capacity_MIMO_NLOS(s) + real(log2(det(eye(M)+(SNR(s)/M)*HH))/numberOfRealizations);
    end
    
end

%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex'); 

figure;
hold on; box on; grid on;
plot(SNRdB,capacity_MIMO_NLOS,'k','LineWidth',2);
plot(SNRdB,capacity_MIMO_LOS,'r--','LineWidth',2);
plot(SNRdB,capacity_SISO_LOS,'k:','LineWidth',2);
xlabel('SNR [dB]','Interpreter','latex');
ylabel('Capacity [bit/symbol]','Interpreter','latex');
ylim([0 40]);
legend({'MIMO (NLOS)','MIMO (LOS)','SISO'},'Interpreter','latex','Location','NorthWest');
set(gca,'fontsize',16);
