%This Matlab script can be used to reproduce Figure 5.37 in the textbook:
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
numberOfRealizations = 100000;

%Set range of SNR values
SNRdB = -10:30;
SNR = db2pow(SNRdB);

%Number of antennas
K = 4;
M = 4;

%Prepare to store capacity values
capacity_MIMO_uncorr4 = zeros(length(SNR),1);
capacity_MIMO_uncorr2 = zeros(length(SNR),1);
capacity_MIMO_corr = zeros(length(SNR),1);



%Generate channel realizations without a scaling factor
E_uncorr = (randn(M,K,numberOfRealizations)+1i*randn(M,K,numberOfRealizations))/sqrt(2);

%Go through all channel realizations
for n = 1:numberOfRealizations

    %Compute the singular values 
    sing_uncorr4 = svd(E_uncorr(:,:,n)); % 4x4 MIMO
    sing_uncorr2 = svd(E_uncorr(1:2,1:2,n)); % 2x2 MIMO

    %Correlated scenario that only uses two dimensions
    E_corr = zeros(4,4);
    E_corr(1:2,1:2) = 2*E_uncorr(1:2,1:2,n);

    %Compute the singular values
    sing_corr = svd(E_corr);

    %Go through all SNR values
    for s = 1:length(SNR)

        %Perform water-filling power allocation with uncorrelated fading
        powerAllocation = functionWaterfilling(SNR(s),1./sing_uncorr4.^2);

        %Compute the ergodic rate with CSI at the transmitter
        capacity_MIMO_uncorr4(s) = capacity_MIMO_uncorr4(s) + sum(log2(1+powerAllocation.*sing_uncorr4.^2))/numberOfRealizations;


        %Perform water-filling power allocation with uncorrelated fading
        powerAllocation = functionWaterfilling(SNR(s),1./sing_uncorr2.^2);

        %Compute the ergodic rate with CSI at the transmitter
        capacity_MIMO_uncorr2(s) = capacity_MIMO_uncorr2(s) + sum(log2(1+powerAllocation.*sing_uncorr2.^2))/numberOfRealizations;


        %Perform water-filling power allocation with correlated fading
        powerAllocation = functionWaterfilling(SNR(s),1./sing_corr.^2);

        %Compute the ergodic rate without CSI at the transmitter
        capacity_MIMO_corr(s) = capacity_MIMO_corr(s) + sum(log2(1+powerAllocation.*sing_corr.^2))/numberOfRealizations;

    end


end




%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;

plot(SNRdB,capacity_MIMO_uncorr4(:,1),'k-','LineWidth',2);
plot(SNRdB,capacity_MIMO_corr(:,1),'r--','LineWidth',2);
plot(SNRdB,capacity_MIMO_uncorr2(:,1),'b-.','LineWidth',2);

xlabel('SNR [dB]','Interpreter','latex');
ylabel('Ergodic capacity [bit/symbol]','Interpreter','latex');
legend({'i.i.d. Rayleigh ($M=K=4$)','correlated Rayleigh ($M=K=4$)','i.i.d. Rayleigh ($M=K=2$)'},'Interpreter','latex','Location','NorthWest');
set(gca,'fontsize',16);

