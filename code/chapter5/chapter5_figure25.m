%This Matlab script can be used to reproduce Figure 5.25 in the textbook:
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
K = 4;
M = 4;

%Generate channel realizations without a scaling factor
E = (randn(M,K,numberOfRealizations)+1i*randn(M,K,numberOfRealizations))/sqrt(2);

%Select the length of the coherence block
L_c = 200;

%Prepare to store capacity values
capacity_SIMO_perfect = zeros(length(SNR),1);
capacity_MIMO_perfect = zeros(length(SNR),1);
capacity_SIMO_imperfect = zeros(length(SNR),1);
capacity_MIMO_imperfect = zeros(length(SNR),1);


%Go through all SNRs
for s = 1:length(SNR)
    
    %SIMO capacity
    capacity_SIMO_perfect(s) = mean(log2(1+SNR(s)*sum(abs(E(:,1,:)).^2,1)));

    %SNR loss due to imperfect CSI
    SNRloss = (1-1/(1+SNR(s)))/(1+SNR(s)/(1+SNR(s)));

    %SIMO rate with imperfect CSI
    capacity_SIMO_imperfect(s) = (1-1/L_c)*mean(log2(1+SNRloss*SNR(s)*sum(abs(E(:,1,:)).^2,1)));


end

%MIMO capacity
for n = 1:numberOfRealizations
    
    EE = E(:,:,n)*E(:,:,n)';
    
    for s = 1:length(SNR)

        SNRloss = (1-1/(1+SNR(s)))/(1+SNR(s)/(1+SNR(s)));

        capacity_MIMO_perfect(s) = capacity_MIMO_perfect(s) + real(log2(det(eye(M)+(SNR(s)/K)*EE))/numberOfRealizations);

        capacity_MIMO_imperfect(s) = capacity_MIMO_imperfect(s) + (1-K/L_c)*real(log2(det(eye(M)+SNRloss*(SNR(s)/K)*EE))/numberOfRealizations);
    end


    
end

%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex'); 

figure;
hold on; box on; grid on;
plot(SNRdB,capacity_MIMO_perfect,'k:','LineWidth',2);
plot(SNRdB,capacity_MIMO_imperfect,'k','LineWidth',2);

plot(SNRdB,capacity_SIMO_perfect,'r-.','LineWidth',2);
plot(SNRdB,capacity_SIMO_imperfect,'r--','LineWidth',2);

xlabel('SNR [dB]','Interpreter','latex');
ylabel('Ergodic rate [bit/symbol]','Interpreter','latex');
ylim([0 40]);
xticks([-10:10:20 27 30]);
legend({'MIMO ($M=K=4$), Perfect CSI','MIMO ($M=K=4$), Imperfect CSI','SIMO ($M=4$), Perfect CSI','SIMO ($M=4$), Imperfect CSI'},'Interpreter','latex','Location','NorthWest');
set(gca,'fontsize',16);

