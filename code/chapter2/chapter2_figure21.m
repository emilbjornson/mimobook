%This Matlab script can be used to reproduce Figure 2.21 in the textbook:
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

seed = 21;
rng(seed);

%Set SNR range
SNRdB = 0:50;
SNR = 10.^(SNRdB/10);

%Exact relationship between SNR and p
pValues = 1-exp(-1./SNR);

%Set number of samples in first approach
L_fixed = 10000;

%Set number of errors to count in the second approach
L_error = 100;

%Prepare to save simulation results
pEstimates_fixed = zeros(length(SNR),1);
pEstimates_variable = zeros(length(SNR),1);

%Go through each SNR value
for n = 1:length(SNR)
    
    %Generate random realizations of a Bernoulli random variable
    uniformRandom = rand(L_fixed,1);
    pEstimates_fixed(n) = mean(uniformRandom<pValues(n));
    
    %Generate random realizations from a negative binomial distribution
    L_success = nbinrnd(L_error,pValues(n));
    pEstimates_variable(n) = (L_error-1)/(L_success+L_error-1);
    
end


%% Plot simulation result
set(groot,'defaultAxesTickLabelInterpreter','latex');  

figure;
hold on; box on; grid on;
plot(SNRdB,pValues,'k-','LineWidth',2);
plot(SNRdB,pEstimates_fixed,'bs--','LineWidth',2);
plot(SNRdB,pEstimates_variable,'rd-.','LineWidth',2);
xlabel('SNR [dB]','Interpreter','latex');
ylabel('Error probability ($p$)','Interpreter','latex');
legend({'Exact curve','$L=10000$ samples','$L_\textrm{error}=100$ errors'},'Interpreter','latex','Location','NorthEast');
set(gca,'YScale','log');
set(gca,'fontsize',16);
ylim([1e-5 1]);
set(gca, 'YTick', [1e-5 1e-4 1e-3 1e-2 1e-1 1]);
