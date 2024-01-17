%This Matlab script can be used to reproduce Figure 5.26 in the textbook:
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
Kvalues = [8 4 4];
Mvalues = [4 4 8];

%Extract the number of cases to be considered
cases = length(Kvalues);

%Select the length of the coherence block
L_c = 200;

%Prepare to store capacity values
capacity_MIMO_imperfect_txrxCSI = zeros(length(SNR),cases);
capacity_MIMO_imperfect_rxCSI = zeros(length(SNR),cases);


%Go through the cases with different number of antennas
for c = 1:cases

    M = Mvalues(c);
    K = Kvalues(c);

    %Generate channel realizations without a scaling factor
    E = (randn(M,K,numberOfRealizations)+1i*randn(M,K,numberOfRealizations))/sqrt(2);


    %Go through all channel realizations
    for n = 1:numberOfRealizations

        %Compute the singular values
        sing = svd(E(:,:,n));

        %Compute the outer product of the channel matrix
        EE = E(:,:,n)*E(:,:,n)';


        %Go through all SNR values
        for s = 1:length(SNR)


            %Compute the SNR loss compared to having perfect CSI
            SNRloss = (1-1/(1+SNR(s)))/(1+SNR(s)/(1+SNR(s)));


            %Perform water-filling power allocation with imperfect CSI
            powerAllocation = functionWaterfilling(SNR(s),1./(SNRloss*sing.^2));

            %Compute the ergodic rate with CSI at the transmitter
            capacity_MIMO_imperfect_txrxCSI(s,c) = capacity_MIMO_imperfect_txrxCSI(s,c) + (1-K/L_c)*sum(log2(1+SNRloss*powerAllocation.*sing.^2))/numberOfRealizations;

            %Compute the ergodic rate without CSI at the transmitter
            capacity_MIMO_imperfect_rxCSI(s,c) = capacity_MIMO_imperfect_rxCSI(s,c) + (1-K/L_c)*real(log2(det(eye(M)+SNRloss*(SNR(s)/K)*EE))/numberOfRealizations);

        end


    end


end


%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(SNRdB,capacity_MIMO_imperfect_txrxCSI(:,1)./capacity_MIMO_imperfect_rxCSI(:,1),'k-','LineWidth',2);
plot(SNRdB,capacity_MIMO_imperfect_txrxCSI(:,2)./capacity_MIMO_imperfect_rxCSI(:,2),'r--','LineWidth',2);
plot(SNRdB,capacity_MIMO_imperfect_txrxCSI(:,3)./capacity_MIMO_imperfect_rxCSI(:,3),'b-.','LineWidth',2);

xlabel('SNR [dB]','Interpreter','latex');
ylabel('Relative rate gain','Interpreter','latex');
ylim([1 4]);
legend({'$K=8,M=4$','$K=M=4$','$K=4,M=8$'},'Interpreter','latex','Location','NorthEast');
set(gca,'fontsize',16);

