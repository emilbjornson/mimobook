%This Matlab script can be used to reproduce Figure 3.19 in the textbook:
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

%Number of antennas
M = 4;
K = 4;


%Number of realizations with random phase values
nbrOfRealizations = 5000;


%Prepare to save simulation results
capacity = zeros(length(SNR),nbrOfRealizations);
capacity_noSVD_SIC = zeros(length(SNR),nbrOfRealizations);
capacity_noSVD_linear = zeros(length(SNR),nbrOfRealizations);



%Go through all random realizations
for ind = 1:nbrOfRealizations

    %Generate one channel matrix where all entries have independent phases
    H = exp(1i*rand(M,K)*2*pi);


    %Compute the singular values
    s = svd(H);
    
    
    for n = 1:length(SNR)
        

        %Perform water-filling power allocation for each SNR value
        powerAllocation = functionWaterfilling(SNR(n),1./s.^2);
        capacity(n,ind) = sum(log2(1+powerAllocation.*s.^2));


        %Compute the rate with LMMSE-SIC
        capacity_noSVD_SIC(n,ind) = log2(det(eye(M)+(SNR(n)/K)*(H*H')));


        %Compute the rate with linear processing
        for k = 1:K
                
            capacity_noSVD_linear(n,ind) = capacity_noSVD_linear(n,ind) + log2(1+H(:,k)'*inv((K/SNR(n))*eye(M)+H*H'-H(:,k)*H(:,k)')*H(:,k));


        end

                
    end

    
end



%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex'); 

figure;
hold on; box on; grid on;
plot(SNRdB,mean(capacity,2),'k','LineWidth',2);
plot(SNRdB,mean(capacity_noSVD_SIC,2),'r--','LineWidth',2);
plot(SNRdB,mean(capacity_noSVD_linear,2),'b-.','LineWidth',2);
xlabel('SNR [dB]','Interpreter','latex');
ylabel('Rate [bit/symbol]','Interpreter','latex');
legend({'Capacity','LMMSE-SIC','Linear'},'Interpreter','latex','Location','NorthWest');
set(gca,'fontsize',16);
